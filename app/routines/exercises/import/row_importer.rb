module Exercises
  module Import
    class RowImporter

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2

      attr_reader :skip_first_row, :author, :copyright_holder

      def split(text, on: /,|\r?\n/)
        text.to_s.split(on).map(&:strip)
      end

      # Parses the text using Markdown
      # Attachments are associated with the given Exercise object
      def parse(text, exercise)
        return nil if text.blank?
        text = text.to_s

        kd = Kramdown::Document.new(text.to_s.strip, attachable: exercise)
        # If only one <p> tag, remove it and just return the nodes below
        kd.root.children = kd.root.children.first.children \
          if kd.root.children.length == 1 && kd.root.children.first.type == :p
        kd.to_html
      end

      def record_failures
        Exercise.transaction do
          @failures = {}

          yield

          @failures.empty? ? \
            Rails.logger.info('Success!') : Rails.logger.error("Failed rows: #{@failures.keys}")
          @failures.each do |key, value|
            Rails.logger.error "Row #{key}: #{value}"
          end
        end
      end

      def import_row(row, index)
        row_number = index + 1 + (skip_first_row ? 1 : 0)
        begin
          perform_row_import(row, row_number)
        rescue StandardError => se
          Rails.logger.error "Failed to import row ##{row_number} - #{se.message}"
          @failures[row_number] = se.to_s
        end
      end

      def perform_row_import(row, row_number)
        id = row[4]

        @id_map ||= {}
        existing_row = @id_map[id]
        raise "Duplicate ID: Rows #{existing_row} and #{row_number}" unless existing_row.nil?
        @id_map[id] = row_number

        ex = Exercise.new

        books = split(row[0])
        book_tags = books.map{ |book| "book:#{book}" }

        chapter = row[1]
        section = row[2]

        lo_tags = split(row[3]).map{ |lo| "lo:#{books.first}:#{chapter}-#{section}-#{lo}" }

        id_tag = "exid:#{books.first}:#{row[4]}"

        cnxmod_tag = "context-cnxmod:#{row[5]}"

        type_tags = split(row[6]).map{ |type| "type:#{type}" }
        dok_tag = "dok:#{row[7]}"
        blooms_tag = "blooms:#{row[8]}"
        time_tag = "time:#{row[10]}"

        ex.tags = book_tags + lo_tags + type_tags + \
                  [id_tag, cnxmod_tag, dok_tag, blooms_tag, time_tag]

        latest_exercise = Exercise.joins([:publication, exercise_tags: :tag])
                                  .where(exercise_tags: {tag: {name: id_tag}})
                                  .order{[publication.number.desc, publication.version.desc]}.first

        unless latest_exercise.nil?
          ex.publication.number = latest_exercise.publication.number
          ex.publication.version = latest_exercise.publication.version + 1
        end

        ex.save!

        list_name = row[13]

        question_stem_content = parse(row[14], ex)

        styles = [Style::MULTIPLE_CHOICE]
        styles << Style::FREE_RESPONSE unless row[12].include?('y')
        explanation = parse(row[15], ex)
        correct_answer_index = row[16].downcase.strip.each_byte.first - 97

        answers = row[17..-1].each_slice(2)

        qq = Question.new
        qq.exercise = ex
        ex.questions << qq

        st = Stem.new
        st.content = question_stem_content
        qq.stems << st

        styles.each do |style|
          styling = Styling.new
          styling.stylable = st
          styling.style = style
          st.stylings << styling
        end

        if author
          au = Author.new
          au.publication = ex.publication
          au.user = author
          ex.publication.authors << au
        end

        if copyright_holder
          cc = CopyrightHolder.new
          cc.publication = ex.publication
          cc.user = copyright_holder
          ex.publication.copyright_holders << cc
        end

        answers.each_with_index do |af, j|
          aa = parse(af.first, ex)
          ff = parse(af.second, ex)
          next if aa.blank?
          an = Answer.new
          an.question = qq
          an.content = aa

          sa = StemAnswer.new
          sa.stem = st
          sa.answer = an
          sa.correctness = j == correct_answer_index ? 1 : 0
          sa.feedback = ff
          st.stem_answers << sa
        end

        if explanation.present?
          sol = CollaboratorSolution.new(solution_type: SolutionType::DETAILED)
          sol.question = qq
          sol.content = explanation
          qq.collaborator_solutions << sol
        end

        list = List.find_by(name: list_name)
        if list.nil?
          list = List.create(name: list_name)

          [author, copyright_holder].compact.uniq.each do |u|
            lo = ListOwner.new
            lo.owner = u
            lo.list = list
            list.list_owners << lo
          end

          list.save!
          Rails.logger.info "Created new list: #{list_name}"
        end

        le = ListExercise.new
        le.exercise = ex
        le.list = list
        ex.list_exercises << le
        ex.save!
        list.list_exercises << le

        if ex.content_equals?(latest_exercise)
          ex.destroy
          skipped = true
        else
          skipped = false
        end

        row = "Imported row ##{row_number}"
        uid = skipped ? "Existing uid: #{latest_exercise.uid}" : "New uid: #{ex.uid}"
        changes = skipped ? "Exercise skipped (no changes)" : \
                            "New #{latest_exercise.nil? ? 'exercise' : 'version'}"
        Rails.logger.info "#{row} - #{uid} - #{changes}"
      end

    end
  end
end

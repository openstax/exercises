module Exercises
  module Import
    class Old::RowImporter

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2

      attr_reader :skip_first_row, :author, :copyright_holder

      def split(text, on: ',')
        text.split(on).map {|t| t.strip}
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
        begin
          perform_row_import(row, index)
        rescue StandardError => se
          Rails.logger.error "Failed to import row ##{index}!"
          @failures[index] = se.to_s
        end
      end

      def perform_row_import(row, index)
        ex = Exercise.new

        book = row[0]
        chapter = row[1]
        section = row[2]
        grouping_tags =  [book, [book, chapter].join('-'), [book, chapter, section].join('-')]

        los = split(row[3])
        lo_tags = los.map {|lo| [book, chapter, lo].join('-')}
        exercise_id_tag = row[4]
        type_tags = split(row[5])
        location_tag = row[6]
        dok_tag = row[7]
        time_tag = row[8]
        display_type_tags = split(row[9])
        blooms_tag = row[10]

        tags = [grouping_tags, lo_tags, exercise_id_tag, type_tags, location_tag,
                dok_tag, time_tag, display_type_tags, blooms_tag].flatten.uniq
        ex.tags = tags

        latest_exercise = Exercise
          .joins([{publication: :publication_group}, {exercise_tags: :tag}])
          .where(exercise_tags: {tag: {name: exercise_id_tag}})
          .order{[publication.publication_group.number.desc, publication.version.desc]}.first

        unless latest_exercise.nil?
          ex.publication.publication_group = latest_exercise.publication.publication_group
          ex.publication.version = latest_exercise.publication.version + 1
        end

        ex.save!

        list_name = row[11]

        question_stem_content = parse(row[12], ex)

        styles = [Style::MULTIPLE_CHOICE]
        styles << Style::FREE_RESPONSE if display_type_tags.include?('display-free-response')
        explanation = parse(row[13], ex)
        correct_answer_index = row[14].downcase.strip.each_byte.first - 97

        answers = row[15..-1].each_slice(2)

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

        ex.save!
        ex.publication.publish.save!

        lpg = ListPublicationGroup.new(
          list: list, publication_group: ex.publication.publication_group
        )
        ex.publication.publication_group.list_publication_groups << lpg
        list.list_publication_groups << lpg

        skipped = ex.content_equals?(latest_exercise) ? ex.destroy : false

        row = "Imported row ##{index + 1}"
        uid = skipped ? "Existing uid: #{latest_exercise.uid}" : "New uid: #{ex.uid}"
        changes = skipped ? "Exercise skipped (no changes)" : \
                            "New #{latest_exercise.nil? ? 'exercise' : 'version'}"
        Rails.logger.info "#{row} - #{uid} - #{changes}"
      end


    end
  end
end

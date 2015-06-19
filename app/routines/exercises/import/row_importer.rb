module Exercises
  module Import
    class RowImporter

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2

      attr_reader :skip_first_row, :author, :copyright_holder

      def split(text, on: ',')
        text.split(on).collect{|t| t.strip}
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

          Rails.logger.info @failures.empty? ? 'Success!' : "Failures: #{@failures.keys}"
          Rails.logger.info @failures.values.join("\n")
        end
      end

      def import_row(row,index)
        begin
          perform_row_import(row,index)
        rescue ActiveRecord::RecordInvalid => e
          @failures[index] = e.to_s
        end
      end

      def perform_row_import(row,index)
        ex = Exercise.new

        book = row[0]
        chapter = row[1]

        los = split(row[2])
        lo_tags = los.collect{|lo| [book, chapter, lo].join('-')}
        exercise_id_tag = row[3]
        type_tags = split(row[4])
        location_tag = row[5]
        dok_tag = row[6]
        time_tag = row[7]
        display_type_tags = split(row[8])
        blooms_tag = row[9]

        tags = [lo_tags, exercise_id_tag, type_tags, location_tag,
                dok_tag, time_tag, display_type_tags, blooms_tag].flatten
        ex.tags = tags

        latest_exercise = Exercise.joins([:publication, exercise_tags: :tag])
                                  .where(exercise_tags: {tag: {name: exercise_id_tag}})
                                  .order{publication.number.desc}.first

        unless latest_exercise.nil?
          ex.publication.number = latest_exercise.publication.number
          ex.publication.version = latest_exercise.publication.version + 1
        end

        ex.save!

        list_name = row[10]

        question_stem_content = parse(row[11], ex)

        styles = [Style::MULTIPLE_CHOICE]
        styles << Style::FREE_RESPONSE if display_type_tags.include?('display-free-response')
        explanation = parse(row[12], ex)
        correct_answer_index = row[13].downcase.strip.each_byte.first - 97

        answers = row[14..-1].each_slice(2)

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
          sol = Solution.new(solution_type: SolutionType::DETAILED)
          sol.question = qq
          sol.content = explanation
          qq.solutions << sol

          if author.present?
            sau = Author.new
            sau.publication = sol.publication
            sau.user = author
            sol.publication.authors << sau
          end

          if copyright_holder.present?
            sc = CopyrightHolder.new
            sc.publication = sol.publication
            sc.user = copyright_holder
            sol.publication.copyright_holders << sc
          end
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

        Rails.logger.info "Imported #{index} exercise(s) - Current uid: #{ex.uid} - New #{
                            'version of existing ' unless latest_exercise.nil?
                          }exercise"
      end


    end
  end
end

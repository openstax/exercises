module Exercises
  module Import
    class RowImporter

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2
      EQUALITY_ASSOCIATIONS = [
        :attachments,
        :logic,
        :tags,
        {
          publication: [
            :derivations, {
              authors: :user,
              copyright_holders: :user,
              editors: :user
            }
          ],
          questions: [
            :hints, {
              answers: :stem_answers,
              stems: [
                :stylings, :combo_choices
              ]
            }
          ]
        }
      ]
      EQUALITY_EXCLUDED_FIELDS = ['id', 'created_at', 'updated_at', 'version',
                                  'published_at', 'yanked_at', 'embargoed_until']

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

        id_tag = "id:#{books.first}:#{row[4]}"

        cnxmod_tag = "cnxmod:#{row[5]}"

        type_tags = split(row[6]).map{ |type| "ost-type:#{type}" }
        dok_tag = "dok:#{row[7]}"
        blooms_tag = "blooms:#{row[8]}"
        time_tag = "time:#{row[10]}"
        display_tag = "display:#{row[11]}"
        requires_choices_tag = "requires-choices:#{row[12]}"

        ex.tags = book_tags + lo_tags + type_tags + \
                  [id_tag, cnxmod_tag, dok_tag, blooms_tag, time_tag,
                   display_tag, requires_choices_tag]

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
        styles << Style::FREE_RESPONSE unless requires_choices_tag.include?('requires-choices:y')
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

        skipped = false
        unless latest_exercise.nil?
          old_attributes = latest_exercise.association_attributes(
            EQUALITY_ASSOCIATIONS, except: EQUALITY_EXCLUDED_FIELDS,
                                   exclude_foreign_keys: true,
                                   transform_arrays_into_sets: true
          )
          new_attributes = ex.association_attributes(
            EQUALITY_ASSOCIATIONS, except: EQUALITY_EXCLUDED_FIELDS,
                                   exclude_foreign_keys: true,
                                   transform_arrays_into_sets: true
          )

          if old_attributes == new_attributes
            ex.destroy
            skipped = true
          end
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

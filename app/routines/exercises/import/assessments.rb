# Imports exercies from a spreadsheet for Assessments
# The first row contains column headers. The only required column is Question Stem.
module Exercises
  module Import
    class Assessments
      AUTHOR_ID = 1
      COPYRIGHT_HOLDER_ID = 2

      lev_routine

      include RowParser

      def exec(filename:, book_uuid:)
        Rails.logger.info { "Filename: #{filename}" }

        author = User.find(AUTHOR_ID)
        copyright_holder = User.find(COPYRIGHT_HOLDER_ID) rescue author # So it works in the dev env with only 1 user

        initialized = false

        question_stem_index = nil
        uuid_index = nil
        section_index = nil

        page_uuid_by_book_location = {}

        nickname_index = nil

        pre_or_post_index = nil

        ancillary_index = nil
        teks_index = nil
        machine_teks_index = nil

        raise_id_index = nil

        background_index = nil
        multi_step_index = nil
        block_index = nil

        answer_choice_indices = nil
        correct_answer_index = nil
        feedback_indices = nil

        detailed_solution_index = nil

        row_number = nil

        multi_step = nil
        exercise = nil
        record_failures do |failures|
          save = ->(exercise, row_number) do
            return if exercise.nil? || row_number.nil?

            begin
              exercise.save!
              exercise.publication.publish.save!

              Rails.logger.info { "Imported row ##{row_number} - New exercise ID: #{exercise.uid}" }
            rescue StandardError => error
              Rails.logger.error { "Failed to import row ##{row_number} - #{error.message}" }
              failures[row_number] = error.to_s
            end
          end

          ProcessSpreadsheet.call(filename: filename, headers: :downcase) do |headers, row, row_index|
            unless initialized
              question_stem_index ||= headers.index do |header|
                header&.start_with?('question') || header&.end_with?('stem')
              end
              raise ArgumentError, 'Could not find "Question Stem" column' if question_stem_index.nil?

              uuid_index ||= headers.index do |header|
                header&.end_with?('uuid') && (
                  header == 'uuid' || header.start_with?('page') || header.start_with?('section')
                )
              end
              section_index ||= headers.index do |header|
                header&.start_with?('section') && !header.include?('uuid') && !header.include?('name')
              end
              Rails.logger.warn { 'Could not find "UUID" or "Section" columns' } \
                if uuid_index.nil? && section_index.nil?

              unless section_index.nil?
                book = OpenStax::Content::Abl.new.books.find { |book| book.uuid == book_uuid }
                raise ArgumentError, "Could not find book with UUID #{book_uuid} in the ABL" if book.nil?
                book.all_pages.each { |page| page_uuid_by_book_location[page.book_location] = page.uuid }
              end

              nickname_index ||= headers.index { |header| header&.include?('nickname') }

              pre_or_post_index ||= headers.index { |header| header&.start_with?('pre') && header.end_with?('post') }
              Rails.logger.warn { 'Could not find "Pre or Post" column' } if pre_or_post_index.nil?

              ancillary_index ||= headers.index { |header| header&.start_with?('ancillary') }

              teks_index ||= headers.index { |header| header&.include?('teks') && !header.include?('machine') }
              machine_teks_index ||= headers.index { |header| header&.include?('machine') && header.include?('teks') }

              raise_id_index ||= headers.index { |header| header&.include?('raise') }

              background_index ||= headers.index { |header| header&.include?('background') }

              multi_step_index ||= headers.index { |header| header&.include?('multi') && header.include?('step') }

              block_index ||= headers.index { |header| header&.include?('block') }

              answer_choice_indices ||= headers.filter_map.with_index do |header, index|
                index if (
                  header&.start_with?('answer') || header&.start_with?('option') || header&.end_with?('choice')
                ) && !header.include?('feedback')
              end
              Rails.logger.warn { 'Could not find "Answer Choice" columns' } if answer_choice_indices.empty?

              correct_answer_index ||= headers.index { |header| header&.start_with?('correct') }
              Rails.logger.warn { 'Could not find "Correct Answer" column' } if correct_answer_index.nil?

              feedback_indices ||= headers.filter_map.with_index do |header, index|
                index if header&.include?('feedback')
              end

              detailed_solution_index ||= headers.index { |header| header&.end_with?('solution') }
              Rails.logger.warn { 'Could not find "Detailed Solution" column' } if detailed_solution_index.nil?

              initialized = true
            end

            row_number = row_index + 1

            # Using row_index here because dealing with the previous row
            if multi_step_index.nil? || multi_step.nil? || row[multi_step_index] != multi_step
              save.call(exercise, row_index)

              multi_step = row[multi_step_index] unless multi_step_index.nil?

              exercise = Exercise.new

              page_uuid = if uuid_index.nil? || row[uuid_index].blank?
                page_uuid_by_book_location[row[section_index].split('.').map(&:to_i)] \
                  unless section_index.nil? || row[section_index].blank?
              else
                row[uuid_index]
              end
              if page_uuid.blank?
                Rails.logger.warn { "Row ##{row_number} has no associated page in the book" } \
                  unless uuid_index.nil? && section_index.nil?
              else
                is_pre = row[pre_or_post_index].downcase == 'pre'
                exercise.tags << "context-cnxmod:#{page_uuid}" unless is_pre
                exercise.tags << "assessment:#{is_pre ? 'preparedness' : 'practice'
                  }:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}" \
                  unless pre_or_post_index.nil? || row[pre_or_post_index].blank?
              end

              exercise.tags << "assessment:practice:https://openstax.org/orn/ancillary/#{row[ancillary_index]}" \
                unless ancillary_index.nil? || row[ancillary_index].blank?

              unless teks_index.nil? || row[teks_index].blank?
                teks = row[teks_index].split(/,|;/).map(&:strip)
                teks.each { |tek| exercise.tags << "teks:#{tek}" }
              end
              unless machine_teks_index.nil? || row[machine_teks_index].blank?
                machine_teks = row[machine_teks_index].split(/,|;/).map(&:strip)
                machine_teks.each { |tek| exercise.tags << "machine-teks:#{tek}" }
              end
              exercise.tags << "raise-content-id:#{row[raise_id_index]}" \
                unless raise_id_index.nil? || row[raise_id_index].blank?

              exercise.publication.authors << Author.new(user: author)
              exercise.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder)

              unless nickname_index.nil? || row[nickname_index].blank?
                existing_pg = PublicationGroup.find_by(nickname: row[nickname_index])

                if existing_pg.nil?
                  exercise.publication.publication_group.nickname = row[nickname_index]
                else
                  exercise.publication.publication_group = existing_pg
                end
              end

              exercise.stimulus = parse(row[background_index], exercise) unless background_index.nil?
            else
              Rails.logger.info { "Imported row ##{row_index} - Multi-step exercise" }
            end

            question = Question.new
            question.sort_position = row[block_index].to_i + 1 unless block_index.nil?
            exercise.questions << question

            stem = Stem.new(content: parse(row[question_stem_index], exercise))
            question.stems << stem

            unless detailed_solution_index.nil? || row[detailed_solution_index].blank?
              solution = CollaboratorSolution.new(
                solution_type: SolutionType::DETAILED,
                content: parse(row[detailed_solution_index], exercise)
              )
              question.collaborator_solutions << solution
            end

            if correct_answer_index.nil? || row[correct_answer_index].blank?
              stem.stylings << Styling.new(style: ::Style::FREE_RESPONSE)
              next
            end

            stem.stylings << Styling.new(style: ::Style::MULTIPLE_CHOICE)

            correct_answer = row[correct_answer_index].downcase.strip.each_byte.first - 97
            answer_choice_indices.each_with_index do |row_index, answer_index|
              content = row[row_index]
              next if content.blank?

              feedback_index = feedback_indices[answer_index]
              feedback = row[feedback_index] unless feedback_index.nil?

              stem.stem_answers << StemAnswer.new(
                answer: Answer.new(question: question, content: parse(content, exercise)),
                correctness: answer_index == correct_answer ? 1 : 0,
                feedback: parse(feedback, exercise)
              )
            end
          end

          save.call(exercise, row_number)
        end
      end
    end
  end
end

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

        uuid_index = nil
        section_index = nil
        question_stem_index = nil
        pre_or_post_index = nil
        answer_choice_indices = nil
        correct_answer_index = nil
        detailed_solution_index = nil
        background_index = nil
        multi_step_index = nil
        block_index = nil
        feedback_indices = nil
        nickname_index = nil
        teks_index = nil
        raise_id_index = nil

        row_number = nil
        exercise = nil
        multi_step = nil
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
            if row_index == 0
              question_stem_index ||= headers.index do |header|
                header&.start_with?('question') || header&.end_with?('stem')
              end
              raise ArgumentError, 'Could not find "Question Stem" column' if question_stem_index.nil?

              uuid_index ||= headers.index { |header| header == 'uuid' || header == 'page uuid' }
              section_index ||= headers.index { |header| header == 'section' }
              Rails.logger.warn { 'Could not find "UUID" or "Section" columns' } \
                if uuid_index.nil? && section_index.nil?

              unless section_index.nil?
                book = OpenStax::Content::Abl.new.approved_books.find { |book| book.uuid == book_uuid }
                page_uuid_by_book_location = {}
                book.all_pages.each { |page| page_uuid_by_book_location[page.book_location] = page.uuid }
                raise ArgumentError, "Could not find book with UUID #{book_uuid} in the ABL" if book.nil?
              end

              nickname_index ||= headers.index { |header| header&.include?('nickname') }

              pre_or_post_index ||= headers.index { |header| header&.start_with?('pre') && header.end_with?('post') }
              Rails.logger.warn { 'Could not find "Pre or Post" column' } if pre_or_post_index.nil?

              teks_index ||= headers.index { |header| header&.include?('teks') }

              raise_id_index ||= headers.index { |header| header&.include?('raise') }

              background_index ||= headers.index { |header| header&.include?('background') }

              multi_step_index ||= headers.index { |header| header&.include?('multi') && header.index?('step') }

              block_index ||= headers.index { |header| header&.include?('block') }

              answer_choice_indices ||= headers.filter_map.with_index do |header, index|
                index if (header&.start_with?('answer') || header&.end_with?('choice')) && !header.include?('feedback')
              end
              Rails.logger.warn { 'Could not find "Answer Choice" columns' } if answer_choice_indices.empty?

              correct_answer_index ||= headers.index { |header| header&.start_with?('correct') }
              Rails.logger.warn { 'Could not find "Correct Answer" column' } if correct_answer_index.nil?

              feedback_indices ||= headers.filter_map.with_index do |header, index|
                index if header&.include?('feedback')
              end

              detailed_solution_index ||= headers.index { |header| header&.end_with?('solution') }
              Rails.logger.warn { 'Could not find "Detailed Solution" column' } if detailed_solution_index.nil?
            end

            row_number = row_index + 1

            # Using row_index here because dealing with the previous row
            if multi_step_index.nil? || row[multi_step_index] != multi_step
              save.call(exercise, row_index)

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
                exercise.tags << "context-cnxmod:#{page_uuid}"
                exercise.tags << "assessment:#{row[pre_or_post_index].downcase == 'pre' ? 'preparedness' : 'practice'
                  }:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}" \
                  unless pre_or_post_index.nil? || row[pre_or_post_index].blank?
              end

              exercise.tags << "teks:#{row[teks_index]}" unless teks_index.nil? || row[teks_index].blank?
              exercise.tags << "raise-id:#{row[raise_id_index]}" \
                unless raise_id_index.nil? || row[raise_id_index].blank?

              exercise.publication.authors << Author.new(user: author)
              exercise.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder)

              exercise.publication.publication_group.nickname = row[nickname_index] unless nickname_index.nil?

              exercise.stimulus = parse(row[background_index], exercise) unless background_index.nil?
            else
              Rails.logger.info { "Imported row ##{row_index} - Multi-step exercise" }
            end

            question = Question.new
            question.sort_position = row[block_index] unless block_index.nil?
            exercise.questions << question

            stem = Stem.new(content: parse(row[question_stem_index], exercise))
            stem.stylings << Styling.new(style: ::Style::MULTIPLE_CHOICE)
            question.stems << stem

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

            detailed_solution = row[detailed_solution_index]
            if detailed_solution.present?
              solution = CollaboratorSolution.new(
                solution_type: SolutionType::DETAILED,
                content: parse(detailed_solution, exercise)
              )
              question.collaborator_solutions << solution
            end
          end

          save.call(exercise, row_number)
        end
      end
    end
  end
end

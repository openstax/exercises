# Imports exercies from a spreadsheet for Assessments
# The first row contains column headers. Required columns:
# UUID (page UUID)
# Pre or Post
# Question Stem
# Answer Choice A
# Answer Choice B
# Answer Choice C
# Answer Choice D
# Correct Answer (A, B, C or D)
# Detailed Solution
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
        pre_or_post_index = nil
        question_stem_index = nil
        answer_choice_indices = nil
        correct_answer_index = nil
        detailed_solution_index = nil
        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, headers: :downcase) do |headers, row, row_index|
            uuid_index ||= headers.index { |header| header == 'uuid' || header == 'page uuid' }

            section_index ||= headers.index { |header| header == 'section' }
            raise ArgumentError, 'Could not find "UUID" or "Section" columns' if uuid_index.nil? && section_index.nil?

            unless section_index.nil?
              book = OpenStax::Content::Abl.new.approved_books.find { |book| book.uuid == book_uuid }
              page_uuid_by_book_location = {}
              book.all_pages.each { |page| page_uuid_by_book_location[page.book_location] = page.uuid }
              raise ArgumentError, "Could not find book with UUID #{book_uuid} in the ABL" if book.nil?
            end

            pre_or_post_index ||= headers.index { |header| header&.start_with?('pre') && header.end_with?('post') }
            raise ArgumentError, 'Could not find "Pre or Post" column' if pre_or_post_index.nil?

            question_stem_index ||= headers.index do |header|
              header&.start_with?('question') || header&.end_with?('stem')
            end
            raise ArgumentError, 'Could not find "Question Stem" column' if question_stem_index.nil?

            answer_choice_indices ||= headers.filter_map.with_index do |header, index|
              index if (header&.start_with?('answer') || header&.end_with?('choice')) && !header.include?('feedback')
            end
            raise ArgumentError, 'Could not find "Answer Choice" columns' if answer_choice_indices.empty?

            feedback_indices ||= headers.filter_map.with_index do |header, index|
              index if header&.include?('feedback')
            end

            correct_answer_index ||= headers.index { |header| header&.start_with?('correct') }
            raise ArgumentError, 'Could not find "Correct Answer" column' if correct_answer_index.nil?

            detailed_solution_index ||= headers.index { |header| header&.end_with?('solution') }
            raise ArgumentError, 'Could not find "Detailed Solution" column' if detailed_solution_index.nil?

            row_number = row_index + 1

            page_uuid = if uuid_index.nil? || row[uuid_index].blank?
              page_uuid_by_book_location[row[section_index].split('.').map(&:to_i)] unless row[section_index].blank?
            else
              row[uuid_index]
            end

            if page_uuid.blank?
              Rails.logger.info { "Skipped row ##{row_number} with blank Section or Page UUID" }
              next
            end

            exercise = Exercise.new

            exercise.tags = [
              "assessment:#{row[pre_or_post_index].downcase == 'pre' ? 'preparedness' : 'practice'
                }:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}",
              "context-cnxmod:#{page_uuid}"
            ]

            question = Question.new
            exercise.questions << question

            stem = Stem.new(content: parse(row[question_stem_index], exercise))
            stem.stylings << Styling.new(style: ::Style::MULTIPLE_CHOICE)
            question.stems << stem

            exercise.publication.authors << Author.new(user: author)
            exercise.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder)

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

            begin
              exercise.save!
              exercise.publication.publish.save!

              Rails.logger.info { "Imported row ##{row_number} - New exercise ID: #{exercise.uid}" }
            rescue StandardError => error
              Rails.logger.error { "Failed to import row ##{row_number} - #{error.message}" }
              failures[row_number] = error.to_s
            end
          end
        end
      end
    end
  end
end

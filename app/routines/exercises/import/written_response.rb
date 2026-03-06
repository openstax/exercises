# Imports written response exercises from a spreadsheet
# The first row contains column headers. Required columns:
# Question Stem
# Section UUID (or Section number, e.g. "1.2", with book_uuid used to look up the page UUID via the ABL)
# Length
# Optional:
# Detailed Solution
module Exercises
  module Import
    class WrittenResponse
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
        detailed_solution_index = nil
        uuid_index = nil
        section_index = nil
        length_index = nil

        page_uuid_by_book_location = {}

        row_number = nil

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

              length_index ||= headers.index { |header| header&.include?('length') || header&.include?('size') }
              raise ArgumentError, 'Could not find "Length" column' if length_index.nil?

              detailed_solution_index ||= headers.index { |header| header&.end_with?('solution') }
              Rails.logger.warn { 'Could not find "Detailed Solution" column' } if detailed_solution_index.nil?

              initialized = true
            end

            row_number = row_index + 1

            # Using row_index here because dealing with the previous row
            save.call(exercise, row_index)

            section_uuid = if uuid_index.nil? || row[uuid_index].blank?
              page_uuid_by_book_location[row[section_index].split('.').map(&:to_i)] \
                unless section_index.nil? || row[section_index].blank?
            else
              row[uuid_index]
            end
            response_length = row[length_index]

            exercise = Exercise.new

            if section_uuid.blank?
              Rails.logger.warn { "Row ##{row_number} has no associated page in the book" } \
                unless uuid_index.nil? && section_index.nil?
            else
              orn = "https://openstax.org/orn/book:page/#{book_uuid}:#{section_uuid}"
              exercise.tags << "context-cnxmod:#{section_uuid}"
              exercise.tags << "written-response:practice:#{orn}"
            end

            exercise.tags << "response-size:#{response_length.downcase}" unless response_length.blank?

            exercise.publication.authors << Author.new(user: author)
            exercise.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder)

            question = Question.new
            exercise.questions << question

            stem = Stem.new(content: parse(row[question_stem_index], exercise))
            stem.stylings << Styling.new(style: ::Style::FREE_RESPONSE)
            question.stems << stem

            unless detailed_solution_index.nil? || row[detailed_solution_index].blank?
              solution = CollaboratorSolution.new(
                solution_type: SolutionType::DETAILED,
                content: parse(row[detailed_solution_index], exercise)
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

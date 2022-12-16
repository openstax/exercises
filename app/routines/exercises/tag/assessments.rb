# Tags Exercises for OpenStax Assessments based on an xlsx file
# Row format:
# - Page/Module UUID
# - Unused column (Section number)
# - 5 Pre-Section Exercise numbers in separate cells
# - 5 Post-Section Exercise numbers in separate cells
module Exercises
  module Tag
    class Assessments
      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:, book_uuid:, skip_first_row: true)
        Rails.logger.info { "Filename: #{filename}" }

        book = Roo::Excelx.new(filename)
        row_offset = skip_first_row ? 1 : 0

        record_failures do |failures|
          book.each_row_streaming(offset: row_offset, pad_cells: true)
              .each_with_index do |row, row_index|
            values = 0.upto(row.size - 1).map do |index|
              row[index]&.value&.to_s
            end.compact
            next if values.size <= 2

            page_uuid = values.first

            pre_section_exercise_numbers = values[2..6].reject(&:blank?).map(&:to_i)
            post_section_exercise_numbers = values[7..11].reject(&:blank?).map(&:to_i)
            exercise_numbers = pre_section_exercise_numbers + post_section_exercise_numbers
            exercises = Exercise.joins(publication: :publication_group)
                                .where(publication: { publication_group: { number: exercise_numbers } })
                                .preload(:tags, publication: :publication_group)
                                .latest

            not_found_numbers = exercise_numbers - exercises.map(&:number)

            Rails.logger.warn do
              "WARNING: Couldn't find any Exercises with numbers #{not_found_numbers.join(', ')}"
            end unless not_found_numbers.empty?

            pre_and_post_section_exercises, remaining_exercises = exercises.partition do |ex|
              pre_section_exercise_numbers.include?(ex.number) && post_section_exercise_numbers.include?(ex.number)
            end
            pre_section_exercises, post_section_exercises = remaining_exercises.partition do |ex|
              pre_section_exercise_numbers.include? ex.number
            end

            pre_section_tag = "assessment:preparedness:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}"
            post_section_tag = "assessment:practice:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}"

            row_number = row_index + row_offset + 1

            begin
              tag pre_and_post_section_exercises, [ pre_section_tag, post_section_tag ], row_number
              tag pre_section_exercises, [ pre_section_tag ], row_number
              tag post_section_exercises, [ post_section_tag ], row_number
            rescue StandardError => se
              Rails.logger.error { "Failed to import row ##{row_number} - #{se.message}" }
              failures[row_number] = se.to_s
            end
          end
        end
      end
    end
  end
end

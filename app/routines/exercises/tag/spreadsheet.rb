# Tags Exercises based on a spreadsheet
# Row format:
# - Exercise UID
# - Tags...
module Exercises
  module Tag
    class Spreadsheet

      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:, skip_first_row: true)
        Rails.logger.info { "Filename: #{filename}" }

        row_offset = skip_first_row ? 1 : 0

        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, offset: row_offset) do |row, row_index|
            values = 0.upto(row.size - 1).map do |index|
              row[index].try!(:value).try!(:to_s)
            end.compact
            next if values.size < 2

            exercise_numbers = values.first.split(',').map(&:to_i)
            exercises = Exercise.joins(publication: :publication_group)
                                .where(publication: {publication_group: {number: exercise_numbers}})
                                .preload(:tags, publication: :publication_group)
                                .latest

            not_found_numbers = exercise_numbers - exercises.map(&:number)

            Rails.logger.warn do
              "WARNING: Couldn't find any Exercises with numbers #{not_found_numbers.join(', ')}"
            end unless not_found_numbers.empty?

            tags = values.slice(1..-1).flat_map { |value| value.split(',') }

            row_number = row_index + row_offset + 1

            begin
              tag(exercises, tags, row_number)
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

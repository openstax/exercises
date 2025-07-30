# Tags Exercises based on a spreadsheet
# Row format:
# - Exercise ID or Nickname
# - Tags...
module Exercises
  module Tag
    class Spreadsheet

      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:)
        Rails.logger.info { "Filename: #{filename}" }

        initialized = false

        query_field = :number

        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, headers: :downcase) do |headers, row, row_index|
            unless initialized
              query_field = :nickname if headers[0].include? 'nickname'
              initialized = true
            end

            values = row.compact
            next if values.size < 2

            exercise_numbers_or_nicknames = values.first.split(',')
            exercises = Exercise.joins(publication: :publication_group)
                                .where(publication: {
                                  publication_group: { query_field => exercise_numbers_or_nicknames }
                                })
                                .preload(:tags, publication: :publication_group)
                                .latest

            # Handle exercise_numbers_or_nicknames being returned as floats
            not_found_numbers_or_nicknames = exercise_numbers_or_nicknames.map do |value|
              value.respond_to?(:round) ? value.round : value
            end - exercises.map(&query_field)

            Rails.logger.warn do
              "WARNING: Couldn't find any Exercises with #{query_field}(s) #{not_found_numbers_or_nicknames.join(', ')}"
            end unless not_found_numbers_or_nicknames.empty?

            tags = values.slice(1..-1).flat_map { |value| value.split(',') }

            row_number = row_index + 1

            begin
              tag exercises, tags
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

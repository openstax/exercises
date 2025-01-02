# Maps Exercises between CNX modules (updating cnxmod tags) using a spreadsheet
# Row format:
# - CNX UUID
# - CNX UUID
module Exercises
  module Map
    class Spreadsheet

      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:, skip_first_row: true)
        Rails.logger.info { "Filename: #{filename}" }

        row_offset = skip_first_row ? 1 : 0

        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, offset: row_offset) do |row, row_index|
            values = row[0..1]
            next if values.any?(&:nil?)

            src_uuids = values.first.split(',')
            src_tags = src_uuids.map { |uuid| "context-cnxmod:#{uuid}" }

            exercises = Exercise.joins(:tags)
                                .where(tags: { name: src_tags })
                                .preload(:tags, publication: :publication_group)
                                .latest

            not_found_tags = src_tags - exercises.flat_map(&:tags).map(&:name)

            Rails.logger.warn do
              "WARNING: Couldn't find any Exercises with tag(s) #{not_found_tags.join(', ')}"
            end unless not_found_tags.empty?

            dest_uuids = values.second.split(',')
            dest_tags = dest_uuids.map { |uuid| "context-cnxmod:#{uuid}" }

            row_number = row_index + 1

            begin
              tag exercises, dest_tags
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

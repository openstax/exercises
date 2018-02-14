# Maps Exercises between CNX modules (updating cnxmod tags) using an xlsx file
# Row format:
# - CNX UUID
# - CNX UUID
module Exercises
  module Map
    class Xlsx

      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:, skip_first_row: true)
        Rails.logger.info { "Filename: #{filename}" }

        book = Roo::Excelx.new(filename)
        row_offset = skip_first_row ? 1 : 0

        record_failures do |failures|
          book.each_row_streaming(offset: row_offset, pad_cells: true)
              .each_with_index do |row, row_index|
            values = (0..1).map { |index| row[index].try!(:value).try!(:to_s) }
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

            row_number = row_index + row_offset + 1

            begin
              tag(exercises, dest_tags, row_number)
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

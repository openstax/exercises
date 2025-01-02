# Removes Exercise tags based on a spreadsheet
# Row format:
# - Exercise Number
# - Tags...
module Exercises
  module Untag
    class Spreadsheet

      lev_routine

      include RowParser

      def exec(filename:, skip_first_row: true)
        Rails.logger.info { "Filename: #{filename}" }

        row_offset = skip_first_row ? 1 : 0

        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, offset: row_offset) do |row, row_index|
            values = row.compact
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
              untag(exercises, tags, row_number)
            rescue StandardError => se
              Rails.logger.error { "Failed to import row ##{row_number} - #{se.message}" }
              failures[row_number] = se.to_s
            end
          end
        end
      end

      def untag(exercises, removed_tags, row_number)
        skipped_uids = []
        unpublished_uids = []
        published_uids = []
        new_uids = []

        exercises.group_by(&:number).each do |_, exs|
          exercise = exs.max_by(&:version)
          current_tags = exercise.tags.map(&:name)
          final_tags = current_tags - removed_tags
          if final_tags == current_tags
            skipped_uids << exercise.uid
            next
          end

          if exercise.is_published?
            tagged_exercise = exercise.new_version
            published_uids << exercise.uid
          else
            tagged_exercise = exercise
            unpublished_uids << exercise.uid
          end

          tagged_exercise.tags = final_tags
          tagged_exercise.save!
          tagged_exercise.publication.publish.save!

          new_uids << tagged_exercise.uid if exercise.is_published?
        end

        Rails.logger.info do
          "Skipped #{skipped_uids.join(', ')} (tags not present)"
        end unless skipped_uids.empty?
        Rails.logger.info do
          "Removed #{removed_tags.join(', ')} from #{
          unpublished_uids.join(', ')} (reused unpublished exercises)"
        end unless unpublished_uids.empty?
        Rails.logger.info do
          "Removed #{removed_tags.join(', ')} from #{
          published_uids.join(', ')} (new exercise uids: #{new_uids.join(', ')})"
        end unless published_uids.empty?
      end

    end

  end
end

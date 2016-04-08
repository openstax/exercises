# Tags Exercises based on an xlsx file

# Reads xlsx
require 'roo'

module Exercises
  module Tag
    class Xlsx

      lev_routine

      # Tags Exercises based on a spreadsheet
      def exec(filename: 'tags.xlsx', skip_first_row: true)
        Rails.logger.info "Reading from #{filename}."

        book = Roo::Excelx.new(filename)
        record_failures do |failures|
          book.each_row_streaming(offset: skip_first_row ? 1 : 0, pad_cells: true)
              .each_with_index do |row, row_index|
            values = 0.upto(row.size - 1).map{ |index| row[index].try(:value).try(:to_s) }.compact
            next if values.size < 2

            exercise_numbers = values.first.split(',').map(&:to_i)
            tags = values.slice(1..-1).flat_map{ |value| value.split(',') }

            row_number = skip_first_row ? row_index + 2 : row_index + 1
            tag(exercise_numbers, tags, row_number, failures)
          end
        end
      end

      def record_failures
        Exercise.transaction do
          @failures = {}

          yield @failures

          @failures.empty? ? \
            Rails.logger.info('Success!') : Rails.logger.error("Failed rows: #{@failures.keys}")
          @failures.each do |key, value|
            Rails.logger.error "Row #{key}: #{value}"
          end
        end
      end

      def tag(exercise_numbers, new_tags, row_number, failures)
        begin
          exercises = Exercise.joins(:publication).where(publication: {number: exercise_numbers})
                              .preload([:publication, :tags]).latest(nil, Publication.unscoped)

          not_found_numbers = exercise_numbers - exercises.map(&:number)

          Rails.logger.warn "WARNING: Couldn't find any Exercises with numbers #{
                            not_found_numbers.join(', ')}" unless not_found_numbers.empty?

          skipped_uids = []
          unpublished_uids = []
          published_uids = []
          new_uids = []

          exercises.each do |exercise|
            current_tags = exercise.tags.map(&:name)
            final_tags = (current_tags + new_tags).uniq
            if final_tags == current_tags
              skipped_uids << exercise.uid
              next
            end

            if exercise.is_published?
              tagged_exercise = exercise.new_version
              published_uids << exercise.uid
              new_uids << tagged_exercise.uid
            else
              tagged_exercise = exercise
              unpublished_uids << exercise.uid
            end

            tagged_exercise.tags = final_tags
            tagged_exercise.save!
            tagged_exercise.publication.publish.save!
          end

          Rails.logger.info "Skipped #{skipped_uids.join(', ')} (already tagged)" \
            unless skipped_uids.empty?
          Rails.logger.info "Tagged #{unpublished_uids.join(', ')} with #{new_tags.join(', ')
                            } (reused unpublished exercises)" unless unpublished_uids.empty?
          Rails.logger.info "Tagged #{published_uids.join(', ')} with #{new_tags.join(', ')
                            } (new exercise uids: #{new_uids.join(', ')})" \
            unless published_uids.empty?
        rescue StandardError => se
          Rails.logger.error "Failed to import row ##{row_number} - #{se.message}"
          failures[row_number] = se.to_s
        end
      end

    end

  end
end

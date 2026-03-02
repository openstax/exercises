# Tags written response exercises based on a spreadsheet
# Row format (headers: "Assessment ID", "Module UUID", "Response Length"):
# - Assessment ID (exercise number, may be a float from XLSX)
# - Module UUID (Section/Page UUID)
# - Response Length (activity type, e.g. "Small", "Medium")
module Exercises
  module Tag
    class WrittenResponse
      lev_routine
      include RowParser

      def exec(filename:, book_uuid:)
        Rails.logger.info { "Filename: #{filename}" }

        exercise_id_index     = nil
        uuid_index            = nil
        response_length_index = nil

        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, headers: :downcase) do |headers, row, row_index|
            exercise_id_index     ||= headers.index { |h| h&.include?('assessment') || h&.include?('exercise') }
            uuid_index            ||= headers.index { |h| h&.include?('uuid') }
            response_length_index ||= headers.index { |h| h&.include?('response') || h&.include?('length') }

            raise ArgumentError, 'Could not find Exercise ID column'     if exercise_id_index.nil?
            raise ArgumentError, 'Could not find UUID column'            if uuid_index.nil?
            raise ArgumentError, 'Could not find Response Length column' if response_length_index.nil?

            exercise_number = Float(row[exercise_id_index]).to_i rescue nil
            section_uuid    = row[uuid_index]
            response_length = row[response_length_index]

            next if exercise_number.nil? || section_uuid.blank? || response_length.blank?

            exercises = Exercise.joins(publication: :publication_group)
                                .where(publication: { publication_group: { number: exercise_number } })
                                .preload(:tags, publication: :publication_group)
                                .latest

            if exercises.empty?
              Rails.logger.warn { "WARNING: Couldn't find any Exercise with number #{exercise_number}" }
              next
            end

            new_tag = "written-response:#{response_length
              }:https://openstax.org/orn/book:page/#{book_uuid}:#{section_uuid}"

            row_number = row_index + 1
            begin
              retag(exercises, new_tag)
            rescue StandardError => se
              Rails.logger.error { "Failed to process row ##{row_number} - #{se.message}" }
              failures[row_number] = se.to_s
            end
          end
        end
      end

      private

      def retag(exercises, new_tag)
        skipped_uids     = []
        unpublished_uids = []
        published_uids   = []
        new_uids         = []
        removed_tags     = []

        exercises.group_by(&:number).each do |_, exs|
          exercise     = exs.max_by(&:version)
          current_tags = exercise.tags.map(&:name)
          stripped     = current_tags.select do |t|
            t.start_with?('assessment:preparedness:', 'assessment:practice:')
          end
          final_tags = (current_tags - stripped + [new_tag]).uniq

          if final_tags == current_tags
            skipped_uids << exercise.uid
            next
          end

          removed_tags |= stripped

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
          "Skipped #{skipped_uids.join(', ')} (no changes needed)"
        end unless skipped_uids.empty?

        unless unpublished_uids.empty?
          Rails.logger.info do
            msg = "Tagged #{unpublished_uids.join(', ')} with #{new_tag}"
            msg += " (removed #{removed_tags.join(', ')})" unless removed_tags.empty?
            msg + " (reused unpublished exercises)"
          end
        end

        unless published_uids.empty?
          Rails.logger.info do
            msg = "Tagged #{published_uids.join(', ')} with #{new_tag}"
            msg += " (removed #{removed_tags.join(', ')})" unless removed_tags.empty?
            msg + " (new exercise uids: #{new_uids.join(', ')})"
          end
        end
      end
    end
  end
end

# Tags Exercises for OpenStax Assessments based on a spreadsheet
# Row format:
# - Page/Module UUID
# - Unused column (Section number)
# - 3 Pre-Section Exercise numbers in separate cells
# - 3 Post-Section Exercise numbers in separate cells
module Exercises
  module Tag
    class Assessments
      lev_routine

      include RowParser
      include ::Exercises::Tagger

      def exec(filename:, book_uuid:)
        Rails.logger.info { "Filename: #{filename}" }

        uuid_index = nil
        pre_indices = nil
        post_indices = nil
        record_failures do |failures|
          ProcessSpreadsheet.call(filename: filename, headers: :downcase) do |headers, row, row_index|
            uuid_index ||= headers.index { |header| header&.include?('uuid') }
            raise ArgumentError, 'Could not find page UUID column' if uuid_index.nil?

            pre_indices ||= headers.filter_map.with_index do |header, index|
              index if header&.include?('pre')
            end
            raise ArgumentError, 'Could not find pre-section columns' if pre_indices.empty?

            post_indices ||= headers.filter_map.with_index do |header, index|
              index if header&.include?('post')
            end
            raise ArgumentError, 'Could not find post-section columns' if post_indices.empty?

            page_uuid = row[uuid_index]
            pre_section_exercise_numbers = row.values_at(*pre_indices).filter_map do |val|
              val.to_i unless val.blank?
            end
            post_section_exercise_numbers = row.values_at(*post_indices).filter_map do |val|
              val.to_i unless val.blank?
            end

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
            cnxmod_tag = "context-cnxmod:#{page_uuid}"

            row_number = row_index + 1

            begin
              tag pre_and_post_section_exercises, [ pre_section_tag, post_section_tag, cnxmod_tag ]
              tag pre_section_exercises, [ pre_section_tag ]
              tag post_section_exercises, [ post_section_tag, cnxmod_tag ]
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

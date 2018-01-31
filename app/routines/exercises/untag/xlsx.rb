# Removes Exercise tags based on an xlsx file

module Exercises
  module Untag
    class Xlsx

      include ::Xlsx::Tagger

      lev_routine

      def tag(exercises, removed_tags, row_number)
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
            new_uids << tagged_exercise.uid
          else
            tagged_exercise = exercise
            unpublished_uids << exercise.uid
          end

          tagged_exercise.tags = final_tags
          tagged_exercise.save!
          tagged_exercise.publication.publish.save!
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

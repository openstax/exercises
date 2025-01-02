module Exercises
  module Tagger
    def tag(exercises, new_tags)
      skipped_uids = []
      unpublished_uids = []
      published_uids = []
      new_uids = []

      exercises.group_by(&:number).each do |_, exs|
        exercise = exs.max_by(&:version)
        current_tags = exercise.tags.map(&:name)
        final_tags = (current_tags + new_tags).uniq
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
        "Skipped #{skipped_uids.join(', ')} (already tagged)"
      end unless skipped_uids.empty?
      Rails.logger.info do
        "Tagged #{unpublished_uids.join(', ')} with #{
        new_tags.join(', ')} (reused unpublished exercises)"
      end unless unpublished_uids.empty?
      Rails.logger.info do
        "Tagged #{published_uids.join(', ')} with #{
        new_tags.join(', ')} (new exercise uids: #{new_uids.join(', ')})"
      end unless published_uids.empty?
    end
  end
end

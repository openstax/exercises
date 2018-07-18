module Exercises
  module Finders

    protected

    def find_exercise
      uid = params[:exercise_id] || params[:id]
      @exercise = Exercise.visible_for(user: current_api_user).with_id(uid).first || \
        raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{uid}")
    end

    def find_exercise_or_create_draft
      Exercise.transaction do
        uid = params[:exercise_id] || params[:id]
        @number, @version = uid.split('@')
        draft_requested = @version == 'draft' || @version == 'd'

        # If a draft has been requested, lock the latest published exercise first
        # so we don't create 2 drafts
        published_exercise = Exercise.published.with_id(@number).lock.first \
          if draft_requested

        # Attempt to find existing exercise
        @exercise = Exercise.visible_for(user: current_api_user).with_id(uid).first
        return unless @exercise.nil?

        # Exercise not found and either draft not requested or
        # no published_exercise so we can't create a draft
        raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{uid}") \
          if published_exercise.nil?

        # Check for permission to create the draft
        OSU::AccessPolicy.require_action_allowed!(
          :new_version, current_api_user, published_exercise
        )

        # Draft requested and published exercise found
        @exercise = published_exercise.new_version
        @exercise.save!
      end
    end

  end
end

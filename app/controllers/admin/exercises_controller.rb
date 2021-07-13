module Admin
  class ExercisesController < BaseController
    def invalid
      invalid_exercise_uids = FindInvalidExercises[].map(&:uid)
      if invalid_exercise_uids.empty?
        flash[:notice] = 'No invalid exercises found'
        redirect_to root_url
      else
        redirect_to "/search?q=uid:#{invalid_exercise_uids.join(',')}"
      end
    end
  end
end

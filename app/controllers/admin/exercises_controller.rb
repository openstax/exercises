module Admin
  class ExercisesController < BaseController
    def invalid
      invalid_exercise_ids = FindInvalidExercises[].map(&:id)
      if invalid_exercise_ids.empty?
        flash[:notice] = 'No invalid exercises found'
        redirect_to root_url
      else
        redirect_to "/exercises/search?q=id:\"#{invalid_exercise_ids.join(',')}\""
      end
    end
  end
end

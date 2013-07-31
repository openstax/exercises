module ExercisesHelper
  def quickview_link(exercise)
    link_to(exercise.summary, quickview_exercise_path(exercise), :remote => true)
  end
end


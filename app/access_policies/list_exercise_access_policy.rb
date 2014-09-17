class ListExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which ListExercise objects.

  def self.action_allowed?(action, requestor, list_exercise)
    case action
    when :create, :destroy
      OSU::AccessPolicy.action_allowed?(:update, requestor, list_exercise.list) && \
      OSU::AccessPolicy.action_allowed?(:show, requestor, list_exercise.exercise)
    else
      false
    end
  end

end

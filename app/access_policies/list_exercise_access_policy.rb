class ListExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which ListExercise objects.

  def self.action_allowed?(action, requestor, list_exercise)
    false
  end

end

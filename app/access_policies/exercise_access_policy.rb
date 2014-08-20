class ExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, exercise)
    false
  end

end

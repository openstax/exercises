class ExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, exercise)
    case action
    when :index
      true
    when :read
      exercise.has_collaborator?(requestor) ||\
        exercise.is_published?
    when :create
      !exercise.persisted?
    when :update, :destroy
      exercise.has_collaborator?(requestor)
    else
      false
    end
  end

end

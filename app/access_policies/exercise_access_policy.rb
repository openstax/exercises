class ExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, exercise)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? && requestor.is_human? && !exercise.persisted?
    when :read
      exercise.is_published? || exercise.has_collaborator?(requestor) || \
      requestor.administrator
    when :update, :destroy
      !exercise.is_published? && exercise.has_collaborator?(requestor) || \
      requestor.administrator
    else
      false
    end
  end

end

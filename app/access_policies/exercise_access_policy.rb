class ExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, exercise)
    case action
    when :read
      true
      #exercise.is_published? || exercise.collaborators.include?(requestor)
    when :create
      !exercise.persisted?
    when :update, :destroy
      !exercise.is_published? && exercise.collaborators.include?(requestor)
    end
  end

end

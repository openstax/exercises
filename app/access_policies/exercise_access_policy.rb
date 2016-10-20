class ExerciseAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, exercise)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? &&
      requestor.is_human? &&
      !exercise.persisted? &&
      exercise.vocab_term_id.nil?
    when :read
      exercise.is_public? ||
      exercise.has_read_permission?(requestor)
    when :update, :destroy
      !exercise.is_published? &&
      exercise.vocab_term_id.nil? &&
      exercise.has_write_permission?(requestor)
    when :new_version
      exercise.is_published? &&
      exercise.vocab_term_id.nil? &&
      exercise.has_write_permission?(requestor)
    else
      false
    end
  end

end

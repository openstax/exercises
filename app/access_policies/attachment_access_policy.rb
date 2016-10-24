class AttachmentAccessPolicy
  # Contains all the rules for which requestors can do what with which Attachments

  def self.action_allowed?(action, requestor, attachment)
    return false if action == :search

    if attachment.parent.is_a?(Exercise)
      case action
      when :create
        !requestor.is_anonymous? &&
        requestor.is_human? &&
        !attachment.persisted? && \
        attachment.parent.has_write_permission?(requestor)
      else
        # If attached to an exercise, then use its policy
        ExerciseAccessPolicy.action_allowed?(action, requestor, attachment.parent)
      end
    else
      # all other types of attachments are currently denied
      false
    end

  end
end

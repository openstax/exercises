class AttachmentAccessPolicy
  # Contains all the rules for which requestors can do what with which Exercise objects.

  def self.action_allowed?(action, requestor, attachment)

    if attachment.parent.is_a?(Exercise)
      case action
      when :create
        !requestor.is_anonymous? && requestor.is_human? && !attachment.persisted?
      else
        # If attached to an exercise, then use it's policy
        ExerciseAccessPolicy.action_allowed?(action, requestor, attachment.parent)
      end
    else
      # all other types of attachments are currently denied
      false
    end

  end
end

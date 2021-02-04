class AttachmentAccessPolicy
  # Contains all the rules for which requestors can do what with which Attachments

  def self.action_allowed?(action, requestor, attachment)
    if attachment.parent.is_a?(Exercise)
      case action
      when :create, :destroy
        # If attached to an exercise, then use its policy
        ExerciseAccessPolicy.action_allowed?(:update, requestor, attachment.parent)
      else
        false
      end
    else
      # all other types of attachments are currently denied
      false
    end
  end
end

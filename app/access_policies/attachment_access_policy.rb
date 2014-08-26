class AttachmentAccessPolicy
  # Contains all the rules for which requestors can do what with which Attachment objects.

  def self.action_allowed?(action, requestor, attachment)
    false
  end

end

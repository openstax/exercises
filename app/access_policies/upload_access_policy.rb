class UploadAccessPolicy
  # Contains all the rules for which requestors can do what with which Upload objects.

  def self.action_allowed?(action, requestor, upload)
    false
  end

end

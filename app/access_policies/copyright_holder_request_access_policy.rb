class CopyrightHolderRequestAccessPolicy
  # Contains all the rules for which requestors can do what with which CopyrightHolderRequest objects.

  def self.action_allowed?(action, requestor, copyright_holder_request)
    false
  end

end

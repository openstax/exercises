class CopyrightHolderAccessPolicy
  # Contains all the rules for which requestors can do what with which CopyrightHolder objects.

  def self.action_allowed?(action, requestor, copyright_holder)
    false
  end

end

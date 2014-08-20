class AdministratorAccessPolicy
  # Contains all the rules for which requestors can do what with which Administrator objects.

  def self.action_allowed?(action, requestor, administrator)
    false
  end

end

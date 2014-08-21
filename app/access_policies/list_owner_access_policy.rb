class ListOwnerAccessPolicy
  # Contains all the rules for which requestors can do what with which ListOwner objects.

  def self.action_allowed?(action, requestor, list_owner)
    false
  end

end

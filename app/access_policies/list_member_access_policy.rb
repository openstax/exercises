class ListMemberAccessPolicy
  # Contains all the rules for which requestors can do what with which ListOwner, ListEditor and ListReader objects.

  def self.action_allowed?(action, requestor, list_member)
    false
  end

end

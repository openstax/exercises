class CollaboratorAccessPolicy
  # Contains all the rules for which requestors can do what with which Collaborator objects.

  def self.action_allowed?(action, requestor, collaborator)
    false
  end

end

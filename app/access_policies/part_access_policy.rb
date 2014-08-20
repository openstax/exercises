class PartAccessPolicy
  # Contains all the rules for which requestors can do what with which Part objects.

  def self.action_allowed?(action, requestor, part)
    false
  end

end

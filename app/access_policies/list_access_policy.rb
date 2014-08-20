class ListAccessPolicy
  # Contains all the rules for which requestors can do what with which List objects.

  def self.action_allowed?(action, requestor, list)
    false
  end

end

class LogicAccessPolicy
  # Contains all the rules for which requestors can do what with which Logic objects.

  def self.action_allowed?(action, requestor, logic)
    false
  end

end

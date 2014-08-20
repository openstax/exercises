class LogicOutputAccessPolicy
  # Contains all the rules for which requestors can do what with which LogicOutput objects.

  def self.action_allowed?(action, requestor, logic_output)
    false
  end

end

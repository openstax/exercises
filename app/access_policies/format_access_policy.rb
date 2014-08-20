class FormatAccessPolicy
  # Contains all the rules for which requestors can do what with which Format objects.

  def self.action_allowed?(action, requestor, format)
    false
  end

end

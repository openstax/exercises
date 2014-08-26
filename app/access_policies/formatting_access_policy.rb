class FormattingAccessPolicy
  # Contains all the rules for which requestors can do what with which Formatting objects.

  def self.action_allowed?(action, requestor, formatting)
    false
  end

end

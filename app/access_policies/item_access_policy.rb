class ItemAccessPolicy
  # Contains all the rules for which requestors can do what with which Item objects.

  def self.action_allowed?(action, requestor, item)
    false
  end

end

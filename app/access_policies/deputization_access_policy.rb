class DeputizationAccessPolicy
  # Contains all the rules for which requestors can do what with which Deputization objects.

  def self.action_allowed?(action, requestor, deputization)
    false
  end

end

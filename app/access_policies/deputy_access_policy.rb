class DeputyAccessPolicy
  # Contains all the rules for which requestors can do what with which Deputy objects.

  def self.action_allowed?(action, requestor, deputy)
    false
  end

end

class PublicationAccessPolicy
  # Contains all the rules for which requestors can do what with which Publication objects.

  def self.action_allowed?(action, requestor, publication)
    false
  end

end

class AuthorAccessPolicy
  # Contains all the rules for which requestors can do what with which Author objects.

  def self.action_allowed?(action, requestor, author)
    false
  end

end

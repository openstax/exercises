class AuthorRequestAccessPolicy
  # Contains all the rules for which requestors can do what with which AuthorRequest objects.

  def self.action_allowed?(action, requestor, author_request)
    false
  end

end

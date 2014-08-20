class LibraryAccessPolicy
  # Contains all the rules for which requestors can do what with which Library objects.

  def self.action_allowed?(action, requestor, library)
    false
  end

end

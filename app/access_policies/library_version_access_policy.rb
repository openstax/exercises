class LibraryVersionAccessPolicy
  # Contains all the rules for which requestors can do what with which LibraryVersion objects.

  def self.action_allowed?(action, requestor, library_version)
    false
  end

end

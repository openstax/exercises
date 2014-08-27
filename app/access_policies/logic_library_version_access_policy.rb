class LogicLibraryVersionAccessPolicy
  # Contains all the rules for which requestors can do what with which LogicLibraryVersion objects.

  def self.action_allowed?(action, requestor, logic_library_version)
    false
  end

end

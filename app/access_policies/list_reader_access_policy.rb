class ListReaderAccessPolicy
  # Contains all the rules for which requestors can do what with which ListReader objects.

  def self.action_allowed?(action, requestor, list_reader)
    false
  end

end

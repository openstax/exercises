class LibraryAccessPolicy
  # Contains all the rules for which requestors can do what with which Library objects.

  def self.action_allowed?(action, requestor, library)
    case action
    when :index
      true
    when :read
      library.has_collaborator?(requestor) ||\
        library.is_published?
    when :create
      library.has_collaborator?(requestor) && \
        !library.is_persisted?
    when :update, :destroy
      library.has_collaborator?(requestor)
    else
      false
    end
  end

end

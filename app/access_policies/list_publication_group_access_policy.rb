class ListPublicationGroupAccessPolicy
  # Contains all the rules for which requestors can do what with which ListPublicationGroups

  def self.action_allowed?(action, requestor, list_publication_group)
    case action
    when :create, :destroy
      OSU::AccessPolicy.action_allowed?(:update, requestor, list_publication_group.list)
    else
      false
    end
  end

end

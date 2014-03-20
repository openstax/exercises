class UserGroupAccessPolicy
  # Contains all the rules for which requestors can do what with which UserGroup objects.
  def self.action_allowed?(action, requestor, user_group)
    case action
    when :read
      user_group.has_user?(requestor) || requestor.is_admin?
    when :create, :update, :destroy
      user_group.has_manager?(requestor) || requestor.is_admin?
    else
      false
    end
  end
end
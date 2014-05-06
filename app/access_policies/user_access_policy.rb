class UserAccessPolicy
  # Contains all the rules for which requestors can do what with which User objects.

  def self.action_allowed?(action, requestor, user)
    if requestor.is_human?
      [:index].include?(action) && !requestor.is_anonymous?
    else
      [:index].include?(action) && !self.nil?
    end
  end

end

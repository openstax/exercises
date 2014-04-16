class UserAccessPolicy
  # Contains all the rules for which requestors can do what with which User objects.

  def self.action_allowed?(action, requestor, user)
  if requestor.is_a?(User) || requestor.is_human?
      # Only admins can currently access the user search API in Exercises
      return requestor.is_admin?
  else
      # Only trusted apps can currently access the user search API in Exercises
      return requestor.trusted
    end
  end

end

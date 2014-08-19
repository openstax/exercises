class LicenseAccessPolicy
  # Contains all the rules for which requestors can do what with which License objects.

  def self.action_allowed?(action, requestor, license)
    # Anyone can read a license
    return true if :show == action

    # Only admins can perform other actions
    [:index, :create, :edit, :update, :destroy].include?(action) && requestor.is_admin?
  end

end

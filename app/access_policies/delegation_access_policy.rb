class DelegationAccessPolicy
  # Contains all the rules for which requestors can do what with which Delegations

  def self.action_allowed?(action, requestor, delegation)
    case action
    when :create, :destroy
      !requestor.is_anonymous? && delegation.delegator == requestor
    else
      false
    end
  end

end

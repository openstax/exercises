class DeputizationAccessPolicy
  # Contains all the rules for which requestors can do what with which Deputizations

  def self.action_allowed?(action, requestor, deputization)
    case action
    when :create, :destroy
      !requestor.is_anonymous? && deputization.deputizer == requestor
    else
      false
    end
  end

end

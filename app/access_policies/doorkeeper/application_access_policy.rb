module Doorkeeper
  class ApplicationAccessPolicy
    # Contains all the rules for which requestors can do what with which Application objects.
    def self.action_allowed?(action, requestor, application)
      case action
      when :read
        application.owner.has_user?(requestor) ||\
        application.owner.container == requestor || requestor.is_admin?
      when :create, :update, :destroy
        application.owner.has_manager?(requestor) ||\
        application.owner.container == requestor || requestor.is_admin?
      else
        false
      end
    end
  end
end
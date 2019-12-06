module Doorkeeper
  class ApplicationAccessPolicy
    # Contains all the rules for which requestors can do what with which Doorkeeper::Applications
    def self.action_allowed?(action, requestor, application)
      case action
      when :read, :update
        requestor.is_human? && !requestor.is_anonymous? &&
        ( requestor.is_administrator? || requestor == application.owner )
      when :create, :destroy
        requestor.is_administrator?
      else
        false
      end
    end
  end
end

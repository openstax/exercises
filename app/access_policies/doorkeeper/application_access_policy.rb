module Doorkeeper
  class ApplicationAccessPolicy
    # Contains all the rules for which requestors can do what with which Doorkeeper::Application objects.
    def self.action_allowed?(action, requestor, application)
      case action
      when :read, :update
        requestor.is_human? && !requestor.is_anonymous? && \
        application.owner.has_member?(requestor.account) || \
        requestor.is_administrator?
      when :create, :destroy
        requestor.is_administrator?
      else
        false
      end
    end
  end
end

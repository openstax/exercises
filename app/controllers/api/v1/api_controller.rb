module Api
  module V1
    class ApiController < ApplicationController      
      skip_before_filter :authenticate_user!
      respond_to :json
      rescue_from Exception, :with => :rescue_from_exception
      
      # TODO doorkeeper users (or rather users who have doorkeeper applications) need to agree to 
      # API terms of use (need to have agreed to it at one time, can't require them to agree when 
      # terms change since their apps are doing the talking) -- this needs more thought

    private

      def current_user
        @current_user ||= doorkeeper_token ? 
                          User.find(doorkeeper_token.resource_owner_id) : 
                          super
        # TODO maybe freak out if current user is anonymous (require we know who person/app is
        # so we can do things like throttling, API terms agreement, etc)
      end

      def rescue_from_exception(exception)
        # See https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453 for error names/symbols

        error = :internal_server_error
        send_email = true
    
        case exception
        when SecurityTransgression
          error = :forbidden
          send_email = false
        when ActiveRecord::RecordNotFound, 
             ActionController::RoutingError,
             ActionController::UnknownController,
             AbstractController::ActionNotFound
          error = :not_found
          send_email = false
        end

        ExceptionNotifier::Notifier.exception_notification(
          request.env,
          exception,
          :data => {:message => "An exception occurred"}
        ).deliver if send_email

        
        Rails.logger.debug("An exception occurred: #{exception.inspect}") if Rails.env.development?

        head error
      end

    end
  end
end
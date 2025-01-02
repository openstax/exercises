ActiveSupport.on_load(:action_controller_base) do
  ActionController::Base.class_exec do
    protect_from_forgery

    layout "layouts/application_body_only"

    helper ApplicationHelper
    helper OpenStax::Utilities::OsuHelper

    helper_method :current_account

    protected

    def current_administrator
      Administrator.where(:account_id => current_account.id).first
    end

    def authenticate_administrator!
      current_administrator || raise(SecurityTransgression)
    end
  end
end

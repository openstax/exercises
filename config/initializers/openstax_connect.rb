OpenStax::Connect.configure do |config|
  config.openstax_services_url = 'http://localhost:2999/' if !Rails.env.production?
  config.openstax_application_id = SECRET_SETTINGS[:openstax_application_id]
  config.openstax_application_secret = SECRET_SETTINGS[:openstax_application_secret]
  config.logout_via = :delete
  config.user_provider = ::User
  config.enable_stubbing = true
end

class OpenStax::Connect::ApplicationController < ActionController::Base
  helper ApplicationAccountBarHelper, ApplicationHelper, ApplicationTopNavHelper, AlertHelper, OpenStax::Utilities::OsuHelper
  layout "layouts/application_body_only"
end
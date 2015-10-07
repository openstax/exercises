require 'openstax_rescue_from'

secrets = Rails.application.secrets

OpenStax::RescueFrom.configure do |config|
  config.raise_exceptions = Rails.application.config.consider_all_requests_local

  config.app_name = 'Exercises'
  config.app_env = secrets.environment_name
  config.contact_name = secrets.exception['contact_name']

  # config.notifier = ExceptionNotifier

  # config.html_error_template_path = 'errors/any'
  # config.html_error_template_layout_name = 'application'

  # config.email_prefix = "[#{app_name}] (#{app_env}) "
  config.sender_address = secrets.exception['sender']
  config.exception_recipients = secrets.exception['recipients']
end

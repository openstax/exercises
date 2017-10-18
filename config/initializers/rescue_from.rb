require 'openstax_rescue_from'

secrets = Rails.application.secrets
exception_secrets = secrets.exception
OpenStax::RescueFrom.configure do |config|
  config.raise_exceptions = Rails.application.config.consider_all_requests_local

  config.app_name = 'Exercises'
  config.app_env = secrets.environment_name
  config.contact_name = exception_secrets['contact_name']

  # config.notifier = ExceptionNotifier

  # config.html_error_template_path = 'errors/any'
  # config.html_error_template_layout_name = 'application'

  # config.email_prefix = "[#{app_name}] (#{app_env}) "
  config.sender_address = exception_secrets['sender']
  config.exception_recipients = exception_secrets['recipients']
end

# Exceptions in controllers might be reraised or not depending on the settings above
ActionController::Base.use_openstax_exception_rescue

# RescueFrom always reraises background exceptions so that the background job may properly fail
ActiveJob::Base.use_openstax_exception_rescue

# URL generation errors are caused by bad routes, for example, and should not be ignored
ExceptionNotifier.ignored_exceptions.delete("ActionController::UrlGenerationError")

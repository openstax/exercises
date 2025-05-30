require 'openstax_rescue_from'

OpenStax::RescueFrom.configure do |config|
  # Show the default Rails exception debugging page on dev
  config.raise_exceptions = ENV['RAISE'].nil? ?
    Rails.application.config.consider_all_requests_local :
    ActiveModel::Type::Boolean.new.cast(ENV['RAISE'])

  config.app_name = 'Exercises'
  config.contact_name = Rails.application.secrets.exception_contact_name&.html_safe

  # Notify devs using sentry
  config.notify_proc = ->(proxy, controller) do
    Sentry.capture_exception(proxy.exception)
  end
  config.notify_background_proc = ->(proxy) do
    Sentry.capture_exception(proxy.exception)
  end
end

OpenStax::RescueFrom.register_exception('Lev::SecurityTransgression', notify: false, status: :forbidden)

ActiveSupport.on_load(:action_controller_base) do
  # Exceptions in controllers are not automatically reraised in production-like environments
  ActionController::Base.use_openstax_exception_rescue
end

ActiveSupport.on_load(:active_job) do
  # RescueFrom always reraises background exceptions so that the background job may properly fail
  ActiveJob::Base.use_openstax_exception_rescue
end

module OpenStax::RescueFrom
  def self.default_friendly_message
    'We had some unexpected trouble with your request.'
  end

  def self.do_reraise
    original = configuration.raise_exceptions
    begin
      configuration.raise_exceptions = true
      yield
    ensure
      configuration.raise_exceptions = original
    end
  end
end

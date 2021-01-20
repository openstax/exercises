Raven.configure do |config|
  sentry_secrets = Rails.application.secrets.sentry

  config.dsn = sentry_secrets[:dsn]
  config.current_environment = Rails.application.secrets.environment_name

  # Send POST data and cookies to Sentry
  config.processors -= [ Raven::Processor::Cookies, Raven::Processor::PostData ]
  config.release = sentry_secrets[:release]

  # Don't log "Sentry is ready" message
  config.silence_ready = true
end if Rails.env.production?

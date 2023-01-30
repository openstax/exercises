OpenStax::Utilities.configure do |config|
  config.status_authenticate = -> do
    authenticate_user!

    next if performed? || request.host != 'exercises.openstax.org' || current_user.is_administrator?

    raise SecurityTransgression
  end

  secrets = Rails.application.secrets
  config.assets_url = secrets.assets_url
  config.environment_name = secrets.environment_name
  config.backend = 'exercises'
  config.frontend = 'tutor-js'
  config.release_version = secrets.release_version
  config.deployment = 'tutor-deployment'
  config.deployment_version = secrets.deployment_version
end

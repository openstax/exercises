OpenStax::Utilities.configure do |config|
  config.status_authenticate = -> do
    authenticate_user!

    next if performed? || request.host != 'exercises.openstax.org' || current_user.is_administrator?

    raise SecurityTransgression
  end
end

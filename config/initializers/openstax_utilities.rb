OpenStax::Utilities.configure do |config|
  config.status_authenticate = -> do
    raise SecurityTransgression unless current_user.is_administrator?
  end
end

OpenStax::Api.configure do |config|
  config.validate_cors_origin = ->(request) { true }
end

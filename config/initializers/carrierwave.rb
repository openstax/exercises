CarrierWave.configure do |config|
  if Rails.env.production?
    require 'fog/aws'

    secrets = Rails.application.secrets['aws']['s3']

    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     secrets['access_key_id'],
      aws_secret_access_key: secrets['secret_access_key'],
      endpoint:              secrets['endpoint_server']
    }
    config.fog_directory  = secrets['bucket_name']
    config.fog_attributes = { 'Cache-Control' => 'max-age=31536000' }
  else
    config.storage = :file
  end
end

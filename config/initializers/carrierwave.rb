require 'addressable/uri'

CarrierWave.configure do |config|
  if Rails.env.production?
    secrets = Rails.application.secrets['aws']['s3']

    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     secrets['access_key_id'],
      aws_secret_access_key: secrets['secret_access_key'],
      endpoint:              secrets['endpoint_server'],
      use_iam_profile:       secrets['access_key_id'].blank?
    }
    config.fog_directory  = secrets['bucket_name']
    config.fog_attributes = { 'Cache-Control' => 'max-age=31536000' }
    config.asset_host = secrets['asset_host']
  else
    config.storage = :file
  end
end

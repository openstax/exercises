require 'addressable/uri'

CarrierWave.configure do |config|
  if Rails.env.production?
    secrets = Rails.application.secrets['aws']['s3']

    fog_credentials = secrets['access_key_id'].blank? ? \
                        { use_iam_profile: true } : \
                        { aws_access_key_id:     secrets['access_key_id'],
                          aws_secret_access_key: secrets['secret_access_key'] }

    config.fog_credentials = fog_credentials.merge(
      provider: 'AWS',
      region:   secrets['region'],
      endpoint: secrets['endpoint_server']
    )
    config.fog_directory  = secrets['bucket_name']
    config.fog_attributes = { 'Cache-Control' => 'max-age=31536000' }
    config.asset_host = secrets['asset_host']
  end

  # Upload to AWS only in the production environment
  config.storage = Rails.env.production? ? 'fog/aws' : :file

  # Image processing is nondeterministic
  config.enable_processing = !Rails.env.test?
end

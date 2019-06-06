require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# For cache entries that should never expire but that we still want to evict if Redis is OOM
NEVER_EXPIRES = 68.years

module Exercises
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    ActiveSupport.escape_html_entities_in_json = false

    # Set the default cache store to Redis
    # This setting cannot be set from an initializer
    # See https://github.com/rails/rails/issues/10908
    redis_secrets = secrets[:redis]
    config.cache_store = :redis_store, {
      url: redis_secrets[:url],
      namespace: redis_secrets[:namespaces][:cache],
      expires_in: 1.day,
      compress: true,
      compress_threshold: 1.kilobyte
    }

  end
end

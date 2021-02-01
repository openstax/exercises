require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# For cache entries that should never expire but that we still want to evict if Redis is OOM
NEVER_EXPIRES = 68.years

module Exercises
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    ActiveSupport.escape_html_entities_in_json = false

    redis_secrets = secrets.redis
    redis_secrets[:url] ||= "rediss://#{
      ":#{redis_secrets[:password]}@" unless redis_secrets[:password].blank? }#{
      redis_secrets[:host]}#{":#{redis_secrets[:port]}" unless redis_secrets[:port].blank?}/#{
      "/#{redis_secrets[:db]}" unless redis_secrets[:db].blank?}"

    # Set the default cache store to Redis
    # This setting cannot be set from an initializer
    # See https://github.com/rails/rails/issues/10908
    config.cache_store = :redis_store, {
      url: redis_secrets[:url],
      namespace: redis_secrets[:namespaces][:cache],
      expires_in: 1.day,
      compress: true,
      compress_threshold: 1.kilobyte
    }

  end
end

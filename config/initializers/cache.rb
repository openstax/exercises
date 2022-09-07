# Clear the Rails cache on code reload (dev environment only)
if Rails.env.development? && !Rails.application.config.cache_classes
  Rails.autoloaders.main.on_unload do |klass, _abspath|
    Rails.cache.clear
  end
end

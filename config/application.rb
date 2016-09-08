require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Letter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Beijing'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'
    config.before_configuration do
      $REDIS_CONFIG = ::YAML::load(File.read(File.join(Rails.root.to_s, 'config/redis.yml')))[Rails.env.to_s]
      config.cache_store = :redis_store, $REDIS_CONFIG['cache']
    end
  end
end

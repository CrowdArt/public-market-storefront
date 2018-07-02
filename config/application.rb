require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Storefront
  class Application < Rails::Application
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), '../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), '../app/overrides/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      require './app/swagger/controllers/base_swagger_controller'

      %w[models controllers].each do |path|
        Dir.glob(File.join(File.dirname(__FILE__), "../app/swagger/#{path}/*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      Dir[Rails.root.join('lib', '**', '*.rb')].each do |path|
        Rails.configuration.cache_classes ? require(path) : load(path)
      end
    end

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      g.test_framework :rspec
    end

    config.active_job.queue_adapter = :sidekiq

    if Rails.env.staging? || Rails.env.production?
      Raven.configure do |config|
        config.dsn = Rails.application.credentials.sentry_dsn if Rails.application.credentials.sentry_dsn
      end

      config.middleware.use Rack::Attack
    end

    config.exceptions_app = routes

    unless Rails.env.test? || Rails.env.api_db?
      config.paperclip_defaults = {
        storage: :fog,
        url: ':gcs_domain_url',
        path: ':class/:id/:style-:basename.:extension',
        fog_directory: Rails.application.credentials.google_bucket,
        fog_credentials: {
          provider: 'Google',
          google_project: Rails.application.credentials.google_project,
          google_client_email: Rails.application.credentials.google_client_email,
          google_json_key_string: Rails.application.credentials.google_json_key_string
        }
      }
    end

    config.cache_store = :dalli_store, nil, {
      pool_size: ENV['WEB_WORKERS'] || 1,
      namespace: 'pms', # public market storefront
      expires_in: 2.weeks,
      compress: true,
      failover: true, # default
      keepalive: true, # default
      socket_timeout: 0.5 # default
    }

    config.action_mailer.preview_path = Rails.root.join('lib', 'mailer_previews')
    config.action_mailer.show_previews = !Rails.env.production?
  end
end

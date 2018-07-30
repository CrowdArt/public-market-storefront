# config/initializers/locale_reloader.rb
# Fix for https://github.com/spree/spree/issues/8783
if Rails.env.development?
  class LocaleReloader
    def initialize(app)
      @app = app
    end

    def call(env)
      I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml").to_s]
      I18n.load_path.uniq!
      I18n.backend.reload!

      @app.call(env)
    end
  end

  Rails.application.config.middleware.use(LocaleReloader)
end
require 'mixpanel-ruby'

module Tracker
  class << self
    # Only log in production and staging
    def method_missing(name, *args, &block)
      if ['staging', 'production'].include?(Rails.env)
        tracker.public_send(name, *args) if tracker.respond_to?(name)
      end
    end

    private

    def tracker
      @@tracker ||= Mixpanel::Tracker.new(Settings.mixpanel_api_key)
    end
  end
end

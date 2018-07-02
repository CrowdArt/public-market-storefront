require 'mixpanel-ruby'

module Tracker
  class << self
    # Only log in production and staging
    def method_missing(name, *args) # rubocop:disable Style/MethodMissingSuper, Style/MissingRespondToMissing
      return unless %w[staging production].include?(Rails.env)
      tracker.public_send(name, *args) if tracker.respond_to?(name)
    end

    private

    def tracker
      @@tracker ||= Mixpanel::Tracker.new(Rails.application.credentials.mixpanel_api_key) # rubocop:disable Style/ClassVars
    end
  end
end

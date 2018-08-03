module PublicMarket
  module Workers
    module Slack
      require 'slack-notifier'

      class NotifierWorker
        include Sidekiq::Worker

        attr_reader :options

        def perform(options)
          @options = options.with_indifferent_access
          send_slack_notification
        end

        private

        def send_slack_notification
          msg = message

          return if msg.blank?

          if Rails.env.development?
            puts "---------- Slack Message: #{msg}"
          else
            notifier = ::Slack::Notifier.new(channel)
            notifier.ping(msg)
          end
        end

        def message
          nil
        end

        def channel_name
          nil
        end

        def channel
          Rails.application.credentials[:"slack_#{channel_name}"]
        end

        def spree_url_helpers
          @spree_url_helpers ||= Spree::Core::Engine.routes.url_helpers
        end
      end
    end
  end
end

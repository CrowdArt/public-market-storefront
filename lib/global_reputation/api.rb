module GlobalReputation
  module Api
    class Base < JsonApiClient::Resource
      self.site = Settings.global_reputation_url || ENV['GLOBAL_REPUTATION_URL']
      self.connection_options = { headers: { 'X-Api-Key' => Settings.global_reputation_key }}
    end

    class Rating < Base
      def display_value
        modification || value
      end

      def value_text
        value.positive? ? 'positive' : 'negative'
      end

      def available_mod
        value.positive? ? -1 : 1
      end

      class << self
        def rate_order(user, order, value)
          vendor = order.vendors.first
          begin
            update_rating(order, user, vendor, value)
          rescue JsonApiClient::Errors::NotAuthorized => e
            message = 'Forgot to setup Global Reputation API?'
            message += ' Run `docker exec global_reputation rake api:create_dev_user`.' if Rails.env.development?
            raise e, message
          end
        end

        private

        # rubocop:disable Metrics/AbcSize, Rails/SkipsModelValidations, Rails/ActiveRecordAliases
        def update_rating(order, user, vendor, value)
          if order.rating_uid
            Rails.logger.info("Updating rating for #{order.rating_uid} with #{value}")
            find(order.rating_uid).first.tap do |r|
              r.update_attributes(value: value)
            end
          else
            Rails.logger.info("Creating rating for #{vendor.name} with #{value}")
            create(sender: user.reputation_uid,
                   receiver: vendor.reputation_uid,
                   value: value).tap do |r|
              user.update_attribute(:reputation_uid, r.sender)
              vendor.update_attribute(:reputation_uid, r.receiver)
              order.update_attribute(:rating_uid, r.id)
            end
          end
        end
        # rubocop:enable Metrics/AbcSize, Rails/SkipsModelValidations, Rails/ActiveRecordAliases
      end
    end

    class Reputation < Base
    end
  end
end

module GlobalReputation
  module Api
    class Base < JsonApiClient::Resource
      self.site = Rails.application.credentials.global_reputation_url || ENV['GLOBAL_REPUTATION_URL']
      self.connection_options = { headers: { 'X-Api-Key' => Rails.application.credentials.global_reputation_key }}
    end

    class Rating < Base
      def display_value
        modification || value
      end

      class << self
        def rate_shipment(user, shipment, value, review = nil)
          vendor = shipment.vendor
          begin
            Rails.cache.delete(Reputation.cache_key(vendor.reputation_uid))
            update_rating(shipment, user, vendor, value, review)
          rescue JsonApiClient::Errors::NotAuthorized => e
            message = 'Forgot to setup Global Reputation API?'
            message += ' Run `docker exec global_reputation rake api:create_dev_user`.' if Rails.env.development?
            raise e, message
          end
        end

        private

        # rubocop:disable Rails/SkipsModelValidations, Rails/ActiveRecordAliases
        def update_rating(shipment, user, vendor, value, review)
          if shipment.rating_uid
            Rails.logger.info("Updating rating for #{shipment.rating_uid} with #{value}")
            find(shipment.rating_uid).first.tap do |r|
              r.update_attributes(value: value, review: review)
            end
          else
            Rails.logger.info("Creating rating for #{vendor.name} with #{value}")
            create_rating(shipment, user, vendor, value, review)
          end
        end

        def create_rating(shipment, user, vendor, value, review)
          create(sender: user.reputation_uid,
                 receiver: vendor.reputation_uid,
                 value: value,
                 review: review).tap do |r|
            user.update_attribute(:reputation_uid, r.sender)
            vendor.update_attribute(:reputation_uid, r.receiver)
            shipment.update_attribute(:rating_uid, r.id)
          end
        end
        # rubocop:enable Rails/SkipsModelValidations, Rails/ActiveRecordAliases
      end
    end

    class Reputation < Base
      def self.cache_key(reputation_uid)
        [:reputation, :v1, reputation_uid]
      end
    end
  end
end

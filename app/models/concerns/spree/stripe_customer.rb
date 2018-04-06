module Spree
  module StripeCustomer
    extend ActiveSupport::Concern

    included do
      after_validation :update_stripe_card, on: :update, if: -> { valid_stripe_card? && has_payment_profile? }
      after_validation :create_stripe_customer, on: :create, if: -> { valid_stripe_card? && !gateway_customer_profile_id }
    end

    def valid_stripe_card?
      errors.empty? && stripe_card?
    end

    def stripe_card?
      payment_method.method_type == 'stripe'
    end

    private

    def create_stripe_customer # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      options = {
        email: user.email,
        login: payment_method.preferred_secret_key,
        address: stripe_bill_address
      }

      source = stripe_update_source
      creditcard = source.gateway_payment_profile_id || source

      response = provider.store(creditcard, options)

      if response.success?
        cc_type = source.cc_type
        response_cc_type = response.params['sources']['data'].first['brand']
        cc_type = payment_method.class::CARD_TYPE_MAPPING[response_cc_type] if payment_method.class::CARD_TYPE_MAPPING.include?(response_cc_type)

        self.cc_type = cc_type
        self.gateway_customer_profile_id = response.params['id']
        self.gateway_payment_profile_id = response.params['default_source'] || response.params['default_card']
      else
        errors.add(:base, stripe_gateway_error(response.message))
      end
    end

    def update_stripe_card
      response = provider.update(gateway_customer_profile_id, gateway_payment_profile_id, card_to_options)
      errors.add(:base, stripe_gateway_error(response.message)) unless response.success?
    end

    def stripe_update_source
      self.cc_type = payment_method.class::CARD_TYPE_MAPPING[cc_type] if payment_method.class::CARD_TYPE_MAPPING.include?(cc_type)
      self
    end

    def stripe_gateway_error(error)
      if error.is_a?(ActiveMerchant::Billing::Response)
        error.params['message'] || error.params['response_reason_text'] || error.message
      else
        error.to_s
      end
    end

    def stripe_bill_address
      options = {
        address1: address.address1,
        address2: address.address2,
        city: address.city,
        zip: address.zipcode
      }

      if (country = address.country)
        options[:country] = country.name
      end

      if (state = address.state)
        options[:state] = state.name
      end

      options
    end

    def card_to_options # rubocop:disable Metrics/AbcSize
      {
        exp_month: month,
        exp_year: year,
        name: name,
        address_city: address.city,
        address_country: address.country.iso,
        address_state: address.state.abbr,
        address_line1: address.address1,
        address_line2: address.address2,
        address_zip: address.zipcode
      }
    end
  end
end

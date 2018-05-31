module Spree
  class PaymentTransfer < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor'
    belongs_to :payment, class_name: 'Spree::Payment'

    has_many :refunds, class_name: 'Spree::Refund', dependent: :destroy

    delegate :currency, to: :payment

    def money
      Spree::Money.new(amount, currency: currency)
    end

    def credit_allowed
      amount - refunds.sum(:amount)
    end

    def amount_plus_fee
      (amount + fee).to_f
    end

    def reverse!(reverse_amount)
      return if response_code.blank?

      reverse_cents = Spree::Money.new(reverse_amount.to_f, currency: payment.currency).money.cents
      response = reverse(reverse_cents)
      response.authorization
    end

    private

    def reverse(reverse_cents)
      response = payment.payment_method.reverse_transfer(reverse_cents, response_code)

      unless response.success?
        logger.error(Spree.t(:gateway_error) + "  #{response.to_yaml}")
        text = response.params['message'] || response.params['response_reason_text'] || response.message
        raise Core::GatewayError, text
      end

      response
    rescue ActiveMerchant::ConnectionError => e
      logger.error(Spree.t(:gateway_error) + "  #{e.inspect}")
      raise Core::GatewayError, Spree.t(:unable_to_connect_to_gateway)
    end
  end
end

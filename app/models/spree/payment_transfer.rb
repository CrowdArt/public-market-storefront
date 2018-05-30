module Spree
  class PaymentTransfer < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor'
    belongs_to :payment, class_name: 'Spree::Payment'

    has_many :log_entries, as: :source, dependent: :destroy

    delegate :currency, to: :payment

    def money
      Spree::Money.new(amount, currency: currency)
    end

    def amount_plus_fee
      (amount + fee).to_f
    end
  end
end

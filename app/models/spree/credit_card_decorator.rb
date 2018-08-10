module Spree
  module CreditCardDecorator
    MAX_NICKNAME_LENGTH = 25

    def self.prepended(base)
      base.include(Spree::StripeCustomer)
      base.extend(Enumerize)
      base.extend(FriendlyId)

      base.friendly_id :slug_candidates, use: %i[slugged scoped], scope: :user

      base.acts_as_paranoid

      base.belongs_to :address, class_name: 'Spree::Address', required: true, dependent: :destroy
      base.accepts_nested_attributes_for :address

      base.validates :month, :year, numericality: { only_integer: true }
      base.validates :name, length: { maximum: MAX_NICKNAME_LENGTH }, allow_blank: true

      base.before_validation :clone_shipping_address, if: :use_shipping?

      # use enumerize instead of simple enum, because using enum lead to error in class_eval https://github.com/spree/spree/issues/5786
      base.enumerize :funding, in: { credit: 0, debit: 1, unknown: 2, prepaid: 3 }, default: :credit, predicates: { prefix: true }

      base.delegate :provider, to: :payment_method

      base.attr_accessor :use_shipping
    end

    def expiry=(expiry) # rubocop:disable Metrics/AbcSize
      self[:month], self[:year] =
        if expiry.match?(%r{\d{2}\s?\/\s?\d{2,4}}) # will match mm/yy and mm / yyyy
          expiry.delete(' ').split('/')
        elsif (match = expiry.match(/(\d{2})(\d{2,4})/)) # will match mmyy and mmyyyy
          [match[1], match[2]]
        end

      if self[:year]
        self[:year] = "20#{self[:year]}" if (self[:year] / 100).zero?
        self[:year] = self[:year].to_i
      end

      self[:month] = self[:month].to_i if self[:month]
    end

    def display_number(show_prefix: false)
      return '' unless last_digits
      prefix =
        case show_prefix
        when false
          nil
        when :short
          'x'
        else
          'XXXX-XXXX-XXXX'
        end

      "#{prefix}-#{last_digits}"
    end

    def name_with_initial
      first_name, last_name = name.split(' ')
      "#{first_name} #{last_name&.first}."
    end

    def use_shipping?
      use_shipping.present?
    end

    private

    def clone_shipping_address
      if (user_address = user.addresses.find_by(id: use_shipping)).present?
        if address.blank?
          self.address = user_address.clone
        else
          address.attributes = user_address.attributes.except('id', 'updated_at', 'created_at')
        end
      end

      address.user_id = nil
    end

    def slug_candidates
      [
        :card_name,
        [:card_name, -> { SecureRandom.uuid.first(5) }]
      ]
    end
  end

  CreditCard.prepend(CreditCardDecorator)
end

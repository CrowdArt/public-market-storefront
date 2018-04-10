Spree::CreditCard.class_eval do
  include Spree::StripeCustomer
  extend Enumerize

  belongs_to :address, class_name: 'Spree::Address', required: true, dependent: :destroy # rubocop:disable Rails/InverseOf
  accepts_nested_attributes_for :address

  validates :month, :year, numericality: { only_integer: true }
  validates :name, presence: true

  before_validation :clone_shipping_address, if: :use_shipping?

  # use enumerize instead of simple enum, because using enum lead to error in class_eval https://github.com/spree/spree/issues/5786
  enumerize :funding, in: { credit: 0, debit: 1, unknown: 2, prepaid: 3 }, default: :credit, predicates: { prefix: true }

  delegate :provider, to: :payment_method

  attr_accessor :use_shipping, :order_id

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

  def display_number
    return '' unless last_digits
    "XXXX-XXXX-XXXX-#{last_digits}"
  end

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end

  private

  def clone_shipping_address # rubocop:disable Metrics/AbcSize
    order = user.orders.find_by(id: order_id) if order_id

    if order
      self.address = order.ship_address.clone
    elsif (user_address = user.addresses.first).present?
      if address.blank?
        self.address = user_address.clone
      else
        address.attributes = user_address.attributes.except('id', 'updated_at', 'created_at')
      end
    end

    address.user_id = nil
  end
end

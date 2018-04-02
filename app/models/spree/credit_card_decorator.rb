Spree::CreditCard.class_eval do
  extend Enumerize

  belongs_to :address, class_name: 'Spree::Address', required: true # rubocop:disable Rails/InverseOf
  accepts_nested_attributes_for :address

  before_validation :clone_shipping_address, if: :use_shipping?
  attr_accessor :use_shipping, :order_id

  # use enumerize instead of simple enum, because using enum lead to error in class_eval https://github.com/spree/spree/issues/5786
  enumerize :funding, in: { credit: 0, debit: 1, unknown: 2, prepaid: 3 }, default: :credit, predicates: { prefix: true }

  private

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end

  def clone_shipping_address
    order = user.orders.find_by(id: order_id) if order_id

    if order
      self.address = order.ship_address.clone
    elsif (user_address = user.addresses.first).present?
      self.address = user_address.clone
    end

    address.user_id = nil
  end
end

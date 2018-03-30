Spree::Order.class_eval do
  before_validation :clone_shipping_address, if: :use_shipping?
  attr_accessor :use_shipping

  Spree::Order.state_machine.before_transition to: :confirm, do: :copy_billing_from_card

  def copy_billing_from_card
    card = valid_credit_cards.first
    return if !user_id || card.blank?
    self.bill_address = card.address.clone
  end

  def persist_user_address!
    return if temporary_address || !user || !user.respond_to?(:persist_order_address)
    user.persist_order_address(self)
  end

  def vendors
    Spree::Vendor.joins(variants: :line_items).where(spree_line_items: { order_id: id })
  end

  def rateable?
    shipped?
  end

  private

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end

  def clone_shipping_address
    if ship_address && bill_address.nil?
      self.bill_address = ship_address.clone
    else
      bill_address.attributes = ship_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end
end

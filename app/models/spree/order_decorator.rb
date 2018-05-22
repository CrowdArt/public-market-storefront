Spree::Order.class_eval do
  checkout_flow do
    go_to_state :payment
    go_to_state :complete
  end

  Spree::Order.state_machine.before_transition to: :complete, do: :copy_billing_from_card

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

  def quantity_left(variant)
    variant.total_on_hand - quantity_of(variant)
  end

  def ptrn_rewards
    line_items.map(&:variant).map(&:product).map(&:estimated_ptrn).sum
  end

  private

  def copy_billing_from_card
    card = valid_credit_cards.first
    return if !user_id || card.blank?
    self.bill_address = card.address.clone
  end
end

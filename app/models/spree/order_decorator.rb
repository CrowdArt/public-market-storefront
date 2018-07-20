Spree::Order.class_eval do
  include PublicMarket::Hashed

  Spree::Order.state_machine.before_transition to: :confirm, do: :copy_billing_from_card
  Spree::Order.state_machine.before_transition to: :complete, do: :send_user_confirmation

  def user_firstname
    user.first_name.presence || billing_address.first_name
  end

  def transition_to_complete!
    ApplicationRecord.transaction do
      while state != 'complete' && self.next; end
    end
  end

  def persist_user_address!
    return if temporary_address || !user || !user.respond_to?(:persist_order_address)
    user.persist_order_address(self)
  end

  def vendors
    Spree::Vendor.joins(variants: :line_items).where(spree_line_items: { order_id: id }).distinct
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

  def paid?
    payment_state == 'paid' ||
      payment_state == 'credit_owed' ||
      (payment_state == 'balance_due' && payments.pending.any?(&:response_code))
  end

  private

  def after_cancel
    shipments.each(&:cancel!)
    payments.where(state: %i[pending completed]).find_each(&:cancel!)

    # Free up authorized store credits
    payments.store_credits.pending.each(&:void!)

    send_cancel_email
    update_with_updater!
  end

  def copy_billing_from_card
    card = valid_credit_cards.first
    return if !user_id || card.blank?
    self.bill_address = card.address.clone
  end

  def send_user_confirmation
    user.send_confirmation_instructions unless user.confirmed?
  end
end

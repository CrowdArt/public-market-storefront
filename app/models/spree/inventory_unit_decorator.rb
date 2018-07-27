Spree::InventoryUnit.class_eval do
  include PublicMarket::Hashed

  unless state_machine.events[:cancel]
    state_machine do
      event :cancel do
        transition to: :canceled, from: :on_hand
      end
      after_transition to: :canceled, do: :after_cancel
    end
  end

  def ordered?
    on_hand? || backordered?
  end

  def allow_ship?
    ordered?
  end

  private

  def after_cancel
    line_item.decrement!(:quantity) # rubocop:disable Rails/SkipsModelValidations
    order.update_with_updater!
    return unless order.inventory_units.all?(&:canceled?)
    order.cancel! if order.allow_cancel?
    true
  end
end

Spree::LineItem.class_eval do
  include PublicMarket::Hashed

  state_machine initial: :ordered do
    event :confirm do
      transition to: :confirmed, from: :ordered
    end

    event :cancel do
      transition to: :canceled, from: :ordered
    end
    after_transition to: :canceled, do: :after_cancel
  end

  def shipment
    @shipment ||= inventory_units.first.shipment
  end

  private

  def after_cancel
    return unless order.line_items.all?(&:canceled?)
    order.cancel!
  end
end

Spree::LineItem.class_eval do
  include PublicMarket::Hashed

  state_machine initial: :ordered do
    event :confirm do
      transition to: :confirmed, from: :ordered
    end

    event :cancel do
      transition to: :canceled, from: :ordered
    end
  end

  def shipment
    @shipment ||= inventory_units.first.shipment
  end
end

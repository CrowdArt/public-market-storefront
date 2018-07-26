Spree::ShipmentHandler.class_eval do
  def perform
    @shipment.inventory_units.select(&:ordered?).each(&:ship!)
    @shipment.touch(:shipped_at) # rubocop:disable Rails/SkipsModelValidations
    update_order_shipment_state
    send_shipped_email
  end
end

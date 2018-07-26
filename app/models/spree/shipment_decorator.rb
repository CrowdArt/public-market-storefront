Spree::Shipment.class_eval do
  def set_up_inventory(state, variant, order, line_item, quantity = 1)
    return if quantity <= 0
    quantity.times do
      inventory_units.create(
        state: state,
        variant_id: variant.id,
        order_id: order.id,
        line_item_id: line_item.id,
        quantity: 1
      )
    end
  end
end

Spree::ShipmentMailer.class_eval do
  def shipped_email(shipment, _resend = false)
    shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
    order = shipment.order

    opts = {
      order_id: order.number,
      first_name: order.shipping_address.first_name,
      line_items_text: line_items_as_text(order.line_items),
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order }),
      shipment_tracking: render_to_string(partial: 'mailer/shipments/shipment_tracking', locals: { shipment: shipment })
    }

    mail_template(order, :order_shipped, opts)
  end
end

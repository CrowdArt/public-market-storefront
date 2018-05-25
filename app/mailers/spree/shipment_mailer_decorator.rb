Spree::ShipmentMailer.class_eval do
  def shipped_email(shipment, _resend = false)
    shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
    order = shipment.order

    opts = {
      order_id: order.number,
      first_name: order.user_firstname,
      line_items_text: line_items_as_text(order.line_items),
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order, shipment: shipment }),
      shipment_tracking: render_to_string(partial: 'mailer/shipments/shipment_tracking', locals: { shipment: shipment }),
      support_url: main_app.freshdesk_url(host: Spree::Store.current.url)
    }

    mail_template(order, :order_shipped, opts)
  end
end

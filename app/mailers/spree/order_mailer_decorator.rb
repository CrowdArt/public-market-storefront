Spree::OrderMailer.class_eval do
  def confirm_email(order, _resend = false)
    order = order.respond_to?(:id) ? order : Spree::Order.find(order)

    opts = {
      category: :order,
      order_id: order.number,
      first_name: order.shipping_address.first_name,
      order_url: spree.order_url(order, host: Spree::Store.current.url),
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order }),
      customer_info: render_to_string(partial: 'mailer/orders/customer_info', locals: { order: order })
    }

    mail_template(order, :order_confirmation, opts)
  end

  def cancel_email(order, _resend = false)
    order = order.respond_to?(:id) ? order : Spree::Order.find(order)

    opts = {
      category: :order,
      order_id: order.number,
      first_name: order.shipping_address.first_name,
      vendor_name: Spree::Vendor.first.name, # use only one seller for S1
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order })
    }

    mail_template(order, :order_cancel, opts)
  end
end

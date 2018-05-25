Spree::OrderMailer.class_eval do
  def confirm_email(order, _resend = false)
    return if order.blank?
    order = order.respond_to?(:id) ? order : Spree::Order.find(order)

    opts = {
      order_id: order.number,
      first_name: order.user_firstname,
      order_url: spree.order_url(order, host: Spree::Store.current.url),
      line_items_text: line_items_as_text(order.line_items),
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order }),
      customer_info: render_to_string(partial: 'mailer/orders/customer_info', locals: { order: order }),
      support_url: main_app.freshdesk_url(host: Spree::Store.current.url)
    }

    mail_template(order, :order_confirmation, opts)
  end

  def cancel_email(order, _resend = false)
    return if order.blank?
    order = order.respond_to?(:id) ? order : Spree::Order.find(order)

    opts = {
      order_id: order.number,
      order_url: spree.order_url(order, host: Spree::Store.current.url),
      first_name: order.user_firstname,
      vendor_name: Spree::Vendor.first.name, # use only one seller for S1
      order_card: render_to_string(partial: 'mailer/orders/order_card', locals: { order: order }),
      support_url: main_app.freshdesk_url(host: Spree::Store.current.url)
    }

    mail_template(order, :order_cancel, opts)
  end
end

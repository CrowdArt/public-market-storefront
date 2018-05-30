Spree::Gateway::StripeGateway.class_eval do
  def transfer(money, source_transaction, destination, gateway_options)
    options = {
      currency: gateway_options[:currency],
      source_transaction: source_transaction,
      destination: destination
    }

    provider.transfer(money, options)
  end

  def fee(payment)
    payment.amount * 0.029 + 0.3
  end
end

ActiveMerchant::Billing::StripeGateway.class_eval do
  def transfer(money, options)
    post = {
      source_transaction: options[:source_transaction],
      destination: options[:destination]
    }
    add_amount(post, money, options, true)

    commit(:post, 'transfers', post, {})
  end
end

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

  def reverse_transfer(money, transfer_id)
    provider.reverse_transfer(money, transfer_id: transfer_id)
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

  def reverse_transfer(money, options)
    post = { amount: money }

    commit(:post, "transfers/#{CGI.escape(options[:transfer_id])}/reversals", post, {})
  end
end

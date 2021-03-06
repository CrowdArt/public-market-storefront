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

  def options_for_purchase_or_auth(money, creditcard, gateway_options)
    options = {}
    options[:description] = Spree.t('payment_description', order_id: gateway_options[:order_id])
    options[:currency] = gateway_options[:currency]

    if (customer = creditcard.gateway_customer_profile_id)
      options[:customer] = customer
    end

    if (token_or_card_id = creditcard.gateway_payment_profile_id)
      creditcard = token_or_card_id
    end

    [money, creditcard, options]
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

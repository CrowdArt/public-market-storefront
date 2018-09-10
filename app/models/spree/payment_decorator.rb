Spree::Payment.class_eval do
  has_many :payment_transfers, class_name: 'Spree::PaymentTransfer', dependent: :destroy

  def process!
    all_vendors_account = order.vendors.all? { |v| v.gateway_account_profile_id.present? }
    raise Spree::Core::GatewayError, Spree.t(:vendors_transfers_failed) unless all_vendors_account

    authorize!
  end

  def capture!
    order.update_with_updater!
    update(amount: order.total)

    process_capture
  end

  def payment_method_fee
    return 0 unless payment_method.respond_to?(:fee)
    payment_method.fee(self)
  end

  private

  def process_capture
    raise Spree::Core::GatewayError, Spree.t(:payment_processing_failed) if response_code.blank?
    create_transfers

    started_processing!
    gateway_action(response_code, :capture, :complete)
    capture_events.create!(amount: amount)
    process_transfers!
  end

  def process_transfers!
    payment_transfers.each { |transfer| process_transfer(transfer) }
  end

  def process_transfer(transfer)
    protect_from_connection_error do
      response = payment_method.send(:transfer,
                                     transfer.money.cents,
                                     response_code,
                                     transfer.vendor.gateway_account_profile_id,
                                     gateway_options)
      record_response(response)

      if response.success?
        transfer.update(response_code: response.authorization)
      else
        gateway_error(response)
      end
    end
  end

  def create_transfers
    order.vendors.order(:id).each do |vendor|
      vendor_view = Spree::Orders::VendorView.new(order, vendor)
      vendor_amount = vendor_view.total
      create_transfer(vendor, vendor_amount, vendor_view.rewards_amount) if vendor_amount.positive?
    end
  end

  def create_transfer(vendor, vendor_amount, rewards_amount)
    fee = payment_method_fee * vendor_amount / amount
    transfer_amount = vendor_amount - fee - rewards_amount

    raise Spree::Core::GatewayError, Spree.t(:vendors_transfer_negative, vendor: vendor.name) unless transfer_amount.positive?
    payment_transfers.create(vendor: vendor, amount: transfer_amount, fee: fee, rewards: rewards_amount)
  end
end

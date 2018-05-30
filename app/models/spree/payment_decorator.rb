Spree::Payment.class_eval do
  has_many :payment_transfers, class_name: 'Spree::PaymentTransfer', dependent: :destroy

  after_create :create_transfers

  def process!
    return unless payment_method

    all_vendors_account = payment_transfers.all? { |t| t.vendor.gateway_account_profile_id.present? }
    raise Spree::Core::GatewayError, Spree.t(:vendors_transfers_failed) unless all_vendors_account

    purchase!
  end

  def payment_method_fee
    return 0 unless payment_method.respond_to?(:fee)
    payment_method.fee(self)
  end

  private

  def process_purchase
    started_processing!
    gateway_action(source, :purchase, :complete)
    payment_transfers.each { |transfer| process_transfer(transfer) } if response_code.present?
    # This won't be called if gateway_action raises a GatewayError
    capture_events.create!(amount: amount)
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
    order.vendors.each do |vendor|
      create_transfer(vendor)
    end
  end

  def create_transfer(vendor)
    vendor_view = Spree::Orders::VendorView.new(order, vendor)
    vendor_amount = vendor_view.total
    fee = payment_method_fee * vendor_amount / amount
    transfer_amount = vendor_amount - fee

    raise Spree::Core::GatewayError, Spree.t(:vendors_transfer_negative, vendor: vendor.name) if transfer_amount.negative?
    payment_transfers.create(vendor: vendor, amount: transfer_amount, fee: fee)
  end
end

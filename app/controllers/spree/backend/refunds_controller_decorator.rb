Spree::Admin::RefundsController.class_eval do
  private

  def build_resource
    super.tap do |refund|
      refund.payment_transfer = refund.payment.payment_transfers.where(vendor: current_spree_vendor).first
      refund.amount = refund.payment_transfer&.credit_allowed
    end
  end
end

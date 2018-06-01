Spree::Refund.class_eval do
  belongs_to :payment_transfer
  validates :payment_transfer, presence: true

  private

  def perform!
    return true if transaction_id.present?

    reversal_id = payment_transfer.reverse!(amount)
    update_reversal_id(reversal_id)

    @response = process!(credit_cents)
    update_transaction_id(@response.authorization)
  end

  def credit_cents
    Spree::Money.new(amount.to_f, currency: payment.currency).money.cents
  end

  def update_reversal_id(reversal_id)
    self.reversal_id = reversal_id
    update_columns(reversal_id: reversal_id)
  end

  def update_transaction_id(transaction_id)
    self.transaction_id = transaction_id
    update_columns(transaction_id: transaction_id)
    update_order
  end

  def amount_is_less_than_or_equal_to_allowed_amount
    return if amount <= payment_transfer.credit_allowed
    errors.add(:amount, :greater_than_allowed)
  end
end

class AddPaymentTransferToRefunds < ActiveRecord::Migration[5.1]
  def change
    add_reference :spree_refunds, :payment_transfer, index: true
    add_column :spree_refunds, :reversal_id, :string
  end
end

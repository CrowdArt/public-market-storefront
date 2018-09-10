class AddRewardsToTransfers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_payment_transfers, :rewards, :decimal, precision: 10, scale: 2
  end
end

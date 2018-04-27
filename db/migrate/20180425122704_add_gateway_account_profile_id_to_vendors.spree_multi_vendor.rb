# This migration comes from spree_multi_vendor (originally 20180424140143)
class AddGatewayAccountProfileIdToVendors < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_vendors, :gateway_account_profile_id, :string
  end
end

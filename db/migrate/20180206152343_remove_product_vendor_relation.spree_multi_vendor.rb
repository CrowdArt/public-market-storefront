# This migration comes from spree_multi_vendor (originally 20180206151659)
class RemoveProductVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_products, :vendor_id
  end
end

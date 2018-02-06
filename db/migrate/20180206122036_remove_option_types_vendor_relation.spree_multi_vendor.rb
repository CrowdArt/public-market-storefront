# This migration comes from spree_multi_vendor (originally 20180206121624)
class RemoveOptionTypesVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_option_types, :vendor_id, :integer
  end
end

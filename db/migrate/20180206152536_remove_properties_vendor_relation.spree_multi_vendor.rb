# This migration comes from spree_multi_vendor (originally 20180206152433)
class RemovePropertiesVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_properties, :vendor_id
  end
end

# This migration comes from spree_multi_vendor (originally 20180201122300)
class AddVendorToUploads < ActiveRecord::Migration[5.1]
  def change
    add_reference :spree_uploads, :vendor, index: true
  end
end

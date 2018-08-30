# This migration comes from spree_multi_vendor (originally 20180829152113)
class AddCustomerSupportEmailAndRemovePresentation < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_vendors, :customer_support_email, :string
    remove_column :spree_vendors, :presentation, :string
  end
end

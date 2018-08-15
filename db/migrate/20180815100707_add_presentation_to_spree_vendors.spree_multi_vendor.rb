# This migration comes from spree_multi_vendor (originally 20180815095421)
class AddPresentationToSpreeVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_vendors, :presentation, :string
  end
end

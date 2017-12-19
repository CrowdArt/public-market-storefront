# This migration comes from spree (originally 20140717185932)
class AddDefaultToSpreeStockLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_stock_locations, :default, :boolean, null: false, default: false unless column_exists? :spree_stock_locations, :default
  end
end

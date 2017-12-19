# This migration comes from spree (originally 20150216173445)
class AddIndexToSpreeStockItemsVariantId < ActiveRecord::Migration[4.2]
  def up
    add_index :spree_stock_items, :variant_id unless index_exists? :spree_stock_items, :variant_id
  end

  def down
    remove_index :spree_stock_items, :variant_id if index_exists? :spree_stock_items, :variant_id
  end
end

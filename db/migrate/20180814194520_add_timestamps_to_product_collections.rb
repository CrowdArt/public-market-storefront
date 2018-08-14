class AddTimestampsToProductCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_product_collections, :created_at, :datetime
    add_column :spree_product_collections, :updated_at, :datetime
  end
end

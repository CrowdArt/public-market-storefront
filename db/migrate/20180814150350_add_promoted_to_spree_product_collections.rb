class AddPromotedToSpreeProductCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_product_collections, :promoted, :boolean, default: false
  end
end

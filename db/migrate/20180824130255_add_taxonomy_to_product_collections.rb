class AddTaxonomyToProductCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_product_collections, :taxonomy_id, :integer
  end
end

class CreateSpreeProductCollectionProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_product_collection_products do |t|
      t.references :product
      # shorter idx name because of the limit is 63 characters
      t.references :product_collection, index: { name: :idx_spree_prod_collection_on_prod_collection_id }
    end

    # shorter name because of the limit is 63 characters
    add_index :spree_product_collection_products, [:product_id, :product_collection_id], unique: true, name: :idx_spree_prod_collection_prods_on_prod_and_prod_collection
  end
end

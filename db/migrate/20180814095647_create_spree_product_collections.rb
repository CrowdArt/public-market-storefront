class CreateSpreeProductCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_product_collections do |t|
      t.string :name
      t.string :slug
    end

    add_index :spree_product_collections, :slug, unique: true
  end
end

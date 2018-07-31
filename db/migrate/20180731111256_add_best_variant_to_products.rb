class AddBestVariantToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :best_variant_id, :integer
  end
end

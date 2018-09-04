class AddUniqueIndexesToVariants < ActiveRecord::Migration[5.2]
  def up
    remove_index :spree_variants, :sku
    add_index :spree_variants, :sku, unique: true, where: 'vendor_id is null'
    add_index :spree_variants, [:sku, :vendor_id], unique: true, where: 'vendor_id is not null'
  end

  def down
    remove_index :spree_variants, :sku
    remove_index :spree_variants, [:sku, :vendor_id]
    add_index :spree_variants, :sku
  end
end

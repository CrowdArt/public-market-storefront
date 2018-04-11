class AddDeletedAtToSpreeAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_addresses, :deleted_at, :datetime
    add_index :spree_addresses, :deleted_at
  end
end

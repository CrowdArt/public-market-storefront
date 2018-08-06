class AddDefaultToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :default, :boolean, null: false, default: false
  end
end

class AddTitleToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :title, :string
  end
end

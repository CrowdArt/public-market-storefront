class AddUserIdToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_addresses, :user_id, :integer, index: true
  end
end

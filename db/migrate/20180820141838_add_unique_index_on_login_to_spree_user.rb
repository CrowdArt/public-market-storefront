class AddUniqueIndexOnLoginToSpreeUser < ActiveRecord::Migration[5.2]
  def change
    add_index :spree_users, :login, unique: true
  end
end

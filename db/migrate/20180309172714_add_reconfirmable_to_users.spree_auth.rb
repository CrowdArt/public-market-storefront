# This migration comes from spree_auth (originally 20180309171327)
class AddReconfirmableToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_users, :unconfirmed_email, :string
  end
end

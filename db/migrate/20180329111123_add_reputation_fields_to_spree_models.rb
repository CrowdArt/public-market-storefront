class AddReputationFieldsToSpreeModels < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :rating_uid, :string
    add_column :spree_vendors, :reputation_uid, :string
    add_column :spree_users, :reputation_uid, :string
  end
end

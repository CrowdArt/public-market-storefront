# This migration comes from spree (originally 20150324104002)
class RemoveUserIndexFromSpreeStateChanges < ActiveRecord::Migration[4.2]
  def up
    remove_index :spree_state_changes, :user_id if index_exists? :spree_state_changes, :user_id
  end

  def down
    add_index :spree_state_changes, :user_id unless index_exists? :spree_state_changes, :user_id
  end
end

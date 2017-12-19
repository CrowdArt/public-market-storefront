# This migration comes from spree (originally 20141009204607)
class AddStoreIdToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_orders, :store_id, :integer
    Spree::Order.where(store_id: nil).update_all(store_id: Spree::Store.default.id) if Spree::Store.default.persisted?
  end
end

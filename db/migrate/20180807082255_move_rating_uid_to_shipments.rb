class MoveRatingUidToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :rating_uid, :string
    remove_column :spree_orders, :rating_uid, :string
  end
end

class AddStateToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_line_items, :state, :string, default: :ordered

    Spree::LineItem.joins(:order).where(spree_orders: { shipment_state: 'shipped' }).update_all(state: :confirmed)
  end
end

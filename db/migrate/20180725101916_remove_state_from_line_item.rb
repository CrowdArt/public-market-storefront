class RemoveStateFromLineItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :spree_line_items, :state
  end
end

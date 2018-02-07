class DropInventoryUploadsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :inventory_uploads
  end
end

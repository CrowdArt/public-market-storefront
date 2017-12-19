class CreateInventoryUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_uploads do |t|
      t.json :upload_data

      t.timestamps
    end
  end
end

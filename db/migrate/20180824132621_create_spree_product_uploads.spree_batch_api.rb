# This migration comes from spree_batch_api (originally 20180824121012)
class CreateSpreeProductUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_product_uploads do |t|
      t.references :product
      t.references :upload
      t.timestamps null: false
    end
  end
end

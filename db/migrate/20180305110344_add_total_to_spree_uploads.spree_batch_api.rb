# This migration comes from spree_batch_api (originally 20180305092431)
class AddTotalToSpreeUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_uploads, :total, :integer, default: 0
    add_column :spree_uploads, :processed, :integer, default: 0
  end
end

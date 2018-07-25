# This migration comes from spree_batch_api (originally 20180725104450)
class AddMetadataToSpreeUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_uploads, :metadata, :json, null: false, default: {}
  end
end

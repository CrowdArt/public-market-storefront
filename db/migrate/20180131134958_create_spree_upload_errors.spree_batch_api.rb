# This migration comes from spree_batch_api (originally 20180129122301)
class CreateSpreeUploadErrors < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_upload_errors do |t|
      t.references :upload
      t.string :message

      t.timestamps
    end
  end
end

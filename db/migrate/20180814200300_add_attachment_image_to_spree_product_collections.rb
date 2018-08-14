class AddAttachmentImageToSpreeProductCollections < ActiveRecord::Migration[5.2]
  def self.up
    change_table :spree_product_collections do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :spree_product_collections, :image
  end
end

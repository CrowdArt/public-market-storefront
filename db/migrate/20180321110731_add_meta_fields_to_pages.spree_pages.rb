# This migration comes from spree_pages (originally 20180321105816)
class AddMetaFieldsToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_pages, :meta_title, :string
    add_column :spree_pages, :meta_description, :string
    add_attachment :spree_pages, :meta_image
  end
end

# This migration comes from spree_pages (originally 20180319090554)
class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :spree_pages, :slug, unique: true
  end
end

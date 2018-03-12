class AddHiddenToSpreeTaxons < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_taxons, :hidden, :boolean, default: false
  end
end

class AddNotesToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_variants, :notes, :text
  end
end

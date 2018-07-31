class AddRewardsToSpreeModels < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_vendors, :rewards, :integer
    add_column :spree_variants, :rewards, :integer
    add_column :spree_line_items, :rewards, :integer
  end
end

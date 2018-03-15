# This migration comes from spree_searchkick (originally 20180315085820)
class AddBoostFactorToSpreeProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_products, :boost_factor, :integer, default: 1
  end
end

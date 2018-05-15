# This migration comes from spree_multi_vendor (originally 20180514123018)
class CreateSpreePriceMarkups < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_price_markups do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :name
      t.references :vendor

      t.timestamps null: false
    end
  end
end

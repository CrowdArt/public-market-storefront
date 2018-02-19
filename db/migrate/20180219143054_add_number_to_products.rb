class AddNumberToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_products, :number, :string
  end
end

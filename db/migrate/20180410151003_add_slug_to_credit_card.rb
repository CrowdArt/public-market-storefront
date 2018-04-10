class AddSlugToCreditCard < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_credit_cards, :slug, :string
    add_index :spree_credit_cards, :slug
  end
end

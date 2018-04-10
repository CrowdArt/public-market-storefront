class AddCardNameToCreditCard < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_credit_cards, :card_name, :string
  end
end

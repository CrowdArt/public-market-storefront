class AddFundingTypeToCreditCards < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_credit_cards, :funding, :integer, default: 0
  end
end

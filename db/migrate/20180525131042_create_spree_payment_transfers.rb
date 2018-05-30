class CreateSpreePaymentTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_payment_transfers do |t|
      t.references :payment
      t.references :vendor
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2
      t.string :response_code

      t.timestamps null: false
    end
  end
end

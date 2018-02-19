class AddUniqueIndexOnNumberToSpreeProducts < ActiveRecord::Migration[5.1]
  def change
    add_index :spree_products, :number, unique: true unless index_exists?(:spree_products, :number, unique: true)

    products = Spree::Product.where(number: nil)

    Searchkick.callbacks(false) do
      products.find_each do |product|
        product.number = product.class.number_generator.method(:generate_permalink).call(product.class)
        product.save
      end
    end
  end
end

require 'ffaker'

Spree::Product.find_each do |product|
  product.variants =
    Array.new(2) do
      sku = FFaker::IdentificationMX.curp
      Spree::Variant.where(sku: sku, product: product).first_or_initialize do |variant|
        variant.sku = sku
        variant.price = Random.rand(20)
        variant.option_values = Spree::OptionValue.order('RANDOM()').first(2)
      end
    end

  product.save
end

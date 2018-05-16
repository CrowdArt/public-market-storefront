require 'ffaker'

Spree::Product.find_each do |product|
  vendor = Spree::Vendor.first
  product.variants =
    Array.new(2) do
      sku = FFaker::IdentificationMX.curp
      Spree::Variant.where(sku: sku, product: product, vendor: vendor).first_or_initialize do |variant|
        variant.sku = sku
        variant.price = variant.cost_price = Random.rand(20)
        variant.option_values = Spree::OptionValue.order('RANDOM()').first(2)
      end
    end

  product.save
end

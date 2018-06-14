collection @products

attributes :name

node(:price) { |product| product.price_in(current_currency).money }

node(:image) do |product|
  product_image_or_default(product, :small)
end

node(:link) { |product| product_path(product) }

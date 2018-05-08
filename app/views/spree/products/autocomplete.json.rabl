collection @products

attributes :name

node(:price) { |product| product.price_in(current_currency).money }
node(:image) { |product| product.variant_images.first.attachment.url(:small) }
node(:link) { |product| product_path(product) }

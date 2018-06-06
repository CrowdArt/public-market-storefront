collection @products

attributes :name

node(:price) { |product| product.price_in(current_currency).money }

node(:image) do |product|
  if (image = product.variant_images.first)
    image.attachment.url(:small)
  else
    image_url('noimage/small.png')
  end
end

node(:link) { |product| product_path(product) }

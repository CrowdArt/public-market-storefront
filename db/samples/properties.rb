require 'ffaker'

Spree::Product.find_each do |product|
  props = {
    'author' => FFaker::Book.author,
    'genre' => FFaker::Book.genre,
    'isbn' => FFaker::Book.isbn
  }

  props.each do |prop_name, prop_value|
    product.set_property(prop_name, prop_value)
  end
end

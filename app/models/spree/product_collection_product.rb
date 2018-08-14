module Spree
  class ProductCollectionProduct < Spree::Base
    belongs_to :product_collection, class_name: 'Spree::ProductCollection'
    belongs_to :product, class_name: 'Spree::Product'
  end
end

module Spree
  class ProductCollection < Spree::Base
    has_many :product_collections_products, class_name: 'Spree::ProductCollectionProduct', dependent: :destroy
    has_many :products, through: :product_collections_products, class_name: 'Spree::Product', source: :product

    extend FriendlyId
    friendly_id :name, use: :slugged

    validates :name, presence: true

    private

    def should_generate_new_friendly_id?
      slug.blank? || super
    end
  end
end

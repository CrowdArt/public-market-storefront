module PublicMarket
  module Variations
    module Music
      class Properties
        class << self
          def variation_properties(product)
            [product.property(:music_format)]
          end

          def author(properties)
            properties.joins(:property)
                      .select('spree_product_properties.property_id, spree_product_properties.value, spree_properties.name as property_name')
                      .find_by(spree_properties: { name: 'artist' })
          end
        end
      end
    end
  end
end

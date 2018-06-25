module PublicMarket
  module Variations
    module Music
      module Properties
        def self.variation_properties(product)
          [product.property(:music_format)]
        end
      end
    end
  end
end

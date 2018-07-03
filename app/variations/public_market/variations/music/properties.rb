module PublicMarket
  module Variations
    module Music
      module Properties
        def self.variation_properties(product)
          [product.property(:music_format)]
        end

        def self.available_variations
          %w[vinyl cd]
        end

        def subtitle(product)
          product.property(:artist)
        end

        def additional_properties(_product)
          []
        end
      end
    end
  end
end

module PublicMarket
  module Variations
    module Music
      module Properties
        module_function

        def variation_properties(product)
          [product.property(:music_format)]
        end

        def available_variations
          %w[vinyl cd]
        end
      end
    end
  end
end

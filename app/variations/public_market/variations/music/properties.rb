module PublicMarket
  module Variations
    module Music
      module Properties
        module_function

        def variation_properties(product)
          [product.property(:music_format)]
        end

        def filter_properties(product)
          variation_properties(product)
        end

        def filterable_variations
          available_variations
        end

        def available_variations
          %w[vinyl cd]
        end
      end
    end
  end
end

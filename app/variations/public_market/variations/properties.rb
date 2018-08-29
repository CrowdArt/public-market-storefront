module PublicMarket
  module Variations
    class Properties
      class << self
        def variation_properties(_product)
          []
        end

        def variation(_product)
          nil
        end

        def available_variations
          [nil]
        end

        def filterable_variations
          []
        end
      end
    end
  end
end

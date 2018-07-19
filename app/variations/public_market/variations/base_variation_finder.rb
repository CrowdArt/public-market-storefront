module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def variation_name(format, _variation)
          format&.titleize
        end
      end
    end
  end
end

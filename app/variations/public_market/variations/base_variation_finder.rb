module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def similar_fields
          %i[name]
        end

        def date_fields
          []
        end

        def variation_name(format, _variation)
          format&.titleize
        end
      end
    end
  end
end

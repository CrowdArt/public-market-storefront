module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def mlt_fields
          %i[name]
        end

        def variation_name(format, _variation)
          format&.titleize
        end
      end
    end
  end
end

module PublicMarket
  module Variations
    module Music
      class VariationFinder < BaseVariationFinder
        class << self
          def filter(where, product)
            where[:name] = product.name
            where[:artist] = product.property('artist')
            where
          end

          def variation_name(format, variation)
            format += " (#{variation[:vinyl_speed]})" if format == 'vinyl'
            format.humanize
          end
        end
      end
    end
  end
end

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
            if format == 'vinyl'
              vinyl_speed = variation.respond_to?(:property) ? variation.property(:vinyl_speed) : variation[:vinyl_speed]
              format += " (#{vinyl_speed})" if vinyl_speed
            end

            format&.humanize
          end
        end
      end
    end
  end
end

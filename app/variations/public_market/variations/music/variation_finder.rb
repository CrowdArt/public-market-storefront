module PublicMarket
  module Variations
    module Music
      class VariationFinder < Variations::VariationFinder
        class << self
          def variation_name(product, variation = product.variation)
            return if variation.blank?

            name = I18n.t("variations.titleized-format.#{variation}", default: variation.titleize)

            if variation == 'vinyl'
              vinyl_speed = product.respond_to?(:property) ? product.property(:vinyl_speed) : product[:vinyl_speed]
              name += " (#{vinyl_speed.upcase})" if vinyl_speed
            end

            name
          end
        end
      end
    end
  end
end

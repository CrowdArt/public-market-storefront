module PublicMarket
  module Variations
    module Music
      class VariationFinder < Variations::VariationFinder
        class << self
          def variation_name(variation, product)
            return if variation.blank?

            if variation == 'vinyl'
              vinyl_speed = product.respond_to?(:property) ? product.property(:vinyl_speed) : product[:vinyl_speed]
              variation += " (#{vinyl_speed.upcase})" if vinyl_speed
            end

            I18n.t("variations.titleized-format.#{variation}", default: variation.titleize)
          end
        end
      end
    end
  end
end

module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def variation_name(format, _variation)
          return if format.blank?
          I18n.t("variations.titleized-format.#{format}", default: format.titleize)
        end

        def card_variation_name(product)
          variation_name(product.variation, product)
        end
      end
    end
  end
end

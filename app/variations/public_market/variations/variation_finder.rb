module PublicMarket
  module Variations
    class VariationFinder
      class << self
        def variation_name(_variation, format = nil)
          return if format.blank?
          I18n.t("variations.titleized-format.#{format}", default: format.titleize)
        end

        def card_variation_name(product)
          name = I18n.t("variations.card_variations.#{product.taxonomy.name}.#{product.variation}", default: product.variation)
          variation_name(product, name)
        end
      end
    end
  end
end

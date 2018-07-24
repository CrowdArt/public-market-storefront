module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def variation_name(format, _variation)
          return if format.blank?
          I18n.t("variations.titleized-format.#{format}", default: format.titleize)
        end
      end
    end
  end
end

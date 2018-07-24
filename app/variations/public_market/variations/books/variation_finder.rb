module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        def self.variation_name(format, _variation)
          return if format.blank?

          child = I18n.t("variations.titleized-format.#{format}", default: format.titleize)
          parent = Properties.find_matching_format([format], Properties.filterable_book_formats)

          [parent.map(&:titleize), child].flatten.uniq.join(': ')
        end
      end
    end
  end
end

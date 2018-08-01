module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        def self.variation_name(variation, product)
          return if variation.blank?

          product_variation = Spree::Product.find_by(id: product[:_id]).variation

          child = I18n.t("variations.titleized-format.#{product_variation}", default: product_variation.titleize)

          if variation == 'other'
            [variation.titleize, child].flatten.uniq.join(': ')
          else
            child
          end
        end
      end
    end
  end
end

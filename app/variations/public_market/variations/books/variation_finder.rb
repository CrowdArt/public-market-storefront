module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        def self.variation_name(root_variation, product)
          return if root_variation.blank?

          product_variation = Spree::Product.find_by(id: product[:_id]).variation

          child = I18n.t("variations.titleized-format.#{product_variation}", default: product_variation.titleize)

          titleized_variation = root_variation.titleize
          # remove root format from unique PM format
          child = child.remove(titleized_variation).strip

          [titleized_variation, child].reject(&:blank?).uniq.join(': ')
        end
      end
    end
  end
end

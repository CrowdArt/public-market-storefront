module PublicMarket
  module Variations
    module Books
      class VariationFinder < Variations::VariationFinder
        class << self
          def variation_name(product, root_variation = product.variation)
            return if root_variation.blank?

            product_variation = product.is_a?(Spree::Product) ? root_variation : Spree::Product.find_by(id: product[:_id]).variation

            child = I18n.t("variations.titleized-format.#{product_variation}", default: product_variation.titleize)

            titleized_variation = root_variation.titleize
            # remove root format from unique PM format
            child = child.remove(titleized_variation).strip

            [titleized_variation, child].reject(&:blank?).uniq.join(': ')
          end

          def card_variation_name(product)
            name = I18n.t("variations.card_variations.books.#{product.variation}", default: product.variation)
            Variations::VariationFinder.variation_name(product, name)
          end
        end
      end
    end
  end
end

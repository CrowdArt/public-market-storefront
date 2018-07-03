module Spree
  module Inventory
    class FindProductVariations < Spree::BaseAction
      param :product
      param :previous_variation, optional: true
      option :filter_by_variation, optional: true, default: proc { nil }

      def call
        finder = variation_finder

        return [] if finder.nil?

        products = Searchers::SimilarProductsSearcher.call(product, filter_by_variation: filter_by_variation)

        finder.results(products.results, product, previous_variation)
      end

      private

      def variation_finder
        return if (taxonomy = product.taxonomy).blank? || taxonomy.variation_module.blank?
        taxonomy.variation_module::VariationFinder
      end
    end
  end
end

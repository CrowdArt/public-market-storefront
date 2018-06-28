module Spree
  module Inventory
    class FindProductVariations < Spree::BaseAction
      param :product
      param :previous_variation, optional: true

      def call # rubocop:disable Metrics/AbcSize
        # TODO: cache
        where = {
          id: { not: [product.id, previous_variation&.id].compact }
        }

        variation = filter_by_taxonomy(where)
        return [] if variation.nil?

        variation.filter(where, product, previous_variation)

        products = Spree::Product.search(
          '*',
          where: where,
          misspellings: { edit_distance: 2 },
          load: false,
          debug: false
        )

        variation.results(products.results, product, previous_variation)
      end

      private

      def filter_by_taxonomy(where)
        return if (taxonomy = product.taxonomy).blank? || taxonomy.variation_module.blank?

        where["#{taxonomy.name.downcase}_ids"] = { not: nil }
        taxonomy.variation_module::VariationFinder
      end
    end
  end
end

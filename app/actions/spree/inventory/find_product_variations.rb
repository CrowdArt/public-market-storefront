module Spree
  module Inventory
    class FindProductVariations < Spree::BaseAction
      param :product
      param :previous_variation, optional: true
      option :filter_by_variation, optional: true, default: proc { nil }

      def call
        # TODO: cache
        where = {}
        where[:variations] = filter_by_variation if filter_by_variation

        variation = filter_by_taxonomy(where)
        return [] if variation.nil?

        variation.filter(where, product)

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

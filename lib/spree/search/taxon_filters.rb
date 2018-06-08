module Spree
  module Search
    module TaxonFilters
      def self.applicable_filters(aggregations, taxon)
        es_filters = []

        es_filters.concat(taxon.taxonomy.variation_module::Filters.applicable_filters(aggregations, MIN_PRODUCTS_TO_FILTER))

        if (es_price_filters = Spree::Search.price_filters(aggregations))
          es_filters << es_price_filters
        end

        es_filters.uniq
      end
    end
  end
end

module Spree
  module Search
    module TaxonFilters
      def self.applicable_filters(aggregations, taxon)
        taxon.taxonomy.variation_module::Filters.applicable_filters(aggregations)
      end
    end
  end
end

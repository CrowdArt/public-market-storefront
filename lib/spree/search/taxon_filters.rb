module Spree
  module Search
    module TaxonFilters
      def self.applicable_filters(aggregations, taxon)
        return [] if (variation_module = taxon.taxonomy.variation_module).blank?
        variation_module::Filters.applicable_filters(aggregations)
      end
    end
  end
end

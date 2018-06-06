module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end

    def taxon_filters(taxon_id)
      aggs = Spree::Config.searcher_class.new(taxon: taxon_id).retrieve_products.aggs
      Spree::Core::SearchkickFilters.applicable_filters(aggs)
    end
  end
end

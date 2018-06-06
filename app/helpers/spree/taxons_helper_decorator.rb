module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end

    def taxon_filters(taxon_id)
      Rails.cache.fetch([:v1, :taxon_filters, taxon_id], expires_in: 1.hour) do
        aggs = Spree::Config.searcher_class
                            .new(taxon: taxon_id, enable_aggs: true)
                            .retrieve_products
                            .aggs
        Spree::Core::SearchkickFilters.applicable_filters(aggs)
      end
    end
  end
end

module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end

    def taxon_filters(taxon_id)
      Rails.cache.fetch([:v2, :taxon_filters, taxon_id], expires_in: 1.hour) do
        aggs = Spree::Config.searcher_class.new(taxon_ids: [taxon_id], enable_aggs: true).call.aggs
        Spree::Search::SearchkickFilters.applicable_filters(aggs)
      end
    end

    def taxon_sortings(taxon)
      Spree::Search::SearchkickSort.applicable_sort_options(taxon)
    end
  end
end

module Spree
  module SearchFiltersHelper
    def search_filters(taxon)
      Rails.cache.fetch([:v1, :search_filters, taxon], expires_in: 1.hour) do
        if taxon
          aggs = Spree::Config.searcher_class.new(taxon_ids: [taxon.id], enable_aggs: true).call.aggs
          Spree::Search::TaxonFilters.applicable_filters(aggs, taxon)
        else
          []
        end
      end
    end

    def search_sorting_options(taxon)
      Spree::Search::SearchkickSort.applicable_sort_options(taxon)
    end
  end
end

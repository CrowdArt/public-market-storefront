module Spree
  module SearchFiltersHelper
    def search_filters
      Rails.cache.fetch([:v2, :search_filters, @taxon], expires_in: 1.hour) do
        opts = { enable_aggs: true }

        opts[:taxon_ids] = [@taxon.id] if @taxon

        aggs = Spree::Config.searcher_class.call(opts).aggs
        Spree::Search::SearchkickFilters.applicable_filters(aggs, taxon: @taxon)
      end
    end

    def search_sorting_options
      Spree::Search::SearchkickSort.applicable_sort_options
    end
  end
end

module Spree
  module SearchFiltersHelper
    def search_filters
      Rails.cache.fetch([:v3, :search_filters, @taxon]) do
        Spree::Search::SearchkickFilters.applicable_filters(taxon: @taxon)
      end
    end

    def search_sorting_options
      Spree::Search::SearchkickSort.applicable_sort_options
    end
  end
end

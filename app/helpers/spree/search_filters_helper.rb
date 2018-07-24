module Spree
  module SearchFiltersHelper
    def search_filters
      Spree::Search::SearchkickFilters.applicable_filters(taxon: @taxon)
    end

    def search_sorting_options
      Spree::Search::SearchkickSort.applicable_sort_options
    end
  end
end

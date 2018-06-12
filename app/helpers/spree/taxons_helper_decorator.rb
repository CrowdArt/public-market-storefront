module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end

    def taxon_filters(taxon)
      Rails.cache.fetch([:v4, :taxon_filters, taxon], expires_in: 1.hour) do
        aggs = Spree::Config.searcher_class.new(taxon_ids: [taxon.id], enable_aggs: true).call.aggs
        Spree::Search::TaxonFilters.applicable_filters(aggs, taxon)
      end
    end

    def taxon_sortings(taxon)
      Spree::Search::SearchkickSort.applicable_sort_options(taxon)
    end
  end
end

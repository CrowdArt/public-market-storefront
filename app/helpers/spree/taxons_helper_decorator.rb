module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxonPreviews.call(taxon)
    end
  end
end

module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end
  end
end

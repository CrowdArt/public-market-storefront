module Spree
  module TaxonsHelper
    def taxons_preview(taxon)
      Spree::Inventory::Searchers::SearchTaxons.new(taxon).call
    end

    def taxon_filters(kind)
      filter_method = "#{kind}_filters"
      respond_to?(filter_method, include_private: true) ? send(filter_method) : []
    end

    private

    def books_filters
      [
        {
          filter: 'Format',
          options: [
            { id: :all, name: 'All Formats' },
            { id: :paper, name: 'Paperback' },
            { id: :hard, name: 'Hardcover' },
            { id: :audio, name: 'Audio-book' },
            { id: :magazine, name: 'Magazine' },
            { id: :ebook, name: 'E-Books' }
          ]
        },
        {
          filter: 'Price',
          options: [
            { id: :any, name: 'Any Price' },
            { id: :less_five, name: 'Under 5$' },
            { id: :between_five_ten, name: '$5-10' },
            { id: :between_eleven_twenty, name: '$11-20' },
            { id: :more_twenty, name: '$20+' }
          ]
        },
        {
          filter: 'Popularity',
          options: [
            { id: :any, name: 'Any Popularity' },
            { id: :any_time, name: 'Any Time Popular' },
            { id: :month, name: 'Popular this Month' }
          ]
        }
      ]
    end
  end
end

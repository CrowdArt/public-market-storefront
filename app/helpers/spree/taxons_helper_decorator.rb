module Spree
  module TaxonsHelper
    # Retrieve products in stock here
    def taxon_preview(taxon, max = 5) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      products = taxon.active_products
                      .in_stock
                      .select('DISTINCT (spree_products.id), spree_products.*, spree_products_taxons.position')
                      .limit(max)

      if products.size < max
        products_arel = Spree::Product.arel_table
        taxon.descendants.each do |child_taxon|
          to_get = max - products.length

          products += child_taxon.active_products
                                 .in_stock
                                 .select('DISTINCT (spree_products.id), spree_products.*, spree_products_taxons.position')
                                 .where(products_arel[:id].not_in(products.map(&:id)))
                                 .limit(to_get)

          break if products.size >= max
        end
      end

      # hide taxon preview if taxon depth < 3 and there are less than 5 results
      # if taxon depth >= 3 always show taxon preview
      return [] if taxon.depth < 3 && products.size != max

      products
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

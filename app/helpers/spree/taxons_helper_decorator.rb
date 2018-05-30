module Spree
  module TaxonsHelper
    # Retrieve products in stock here
    def taxon_preview(taxon, max = 4) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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

      products
    end
  end
end

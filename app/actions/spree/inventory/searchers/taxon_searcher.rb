module Spree
  module Inventory
    module Searchers
      class TaxonSearcher < BaseSearcher
        param :taxon

        def call
          result = search_products.aggs
          @buckets = result.dig('categories', 'buckets')

          taxon.children
               .visible
               .reorder(:name)
               .map(&method(:find_bucket))
               .compact
        end

        def where
          { taxon_ids: taxon.id } if taxon.present?
        end

        def aggs
          {
            categories: {
              terms: { field: :taxon_ids, size: 1000, min_doc_count: 1 }
            }
          }
        end

        private

        def find_bucket(child_taxon)
          bucket = @buckets.find { |b| b['key'] == child_taxon.id }
          child_taxon if bucket.present?
        end
      end
    end
  end
end

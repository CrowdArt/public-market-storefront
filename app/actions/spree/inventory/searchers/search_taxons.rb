module Spree
  module Inventory
    module Searchers
      class SearchTaxons < BaseSearcher
        param :taxon

        def call
          result = search_products.aggs
          @buckets = result.dig('categories', 'buckets')
          pp @buckets

          taxon.children
               .map(&method(:find_bucket))
               .compact
               .sort_by(&method(:sort_taxons))
        end

        def where
          { taxon_ids: taxon.id } if taxon.present?
        end

        def aggs
          {
            categories: {
              terms: { field: :taxon_ids, size: 1000 },
              aggs: {
                score: {
                  avg: { script: { source: '_score' }}
                },
                products: {
                  top_hits: { size: 5, _source: { includes: [:_id] }}
                }
              }
            }
          }
        end

        private

        def find_bucket(child_taxon)
          bucket = @buckets.find { |b| b['key'] == child_taxon.id }
          return if bucket.blank?
          return if bucket['doc_count'] < 5 && taxon.depth < 3

          {
            taxon: child_taxon,
            score: bucket.dig('score', 'value').to_f,
            products: bucket_products(bucket)
          }
        end

        def sort_taxons(taxon)
          [taxon[:taxon].hidden, -taxon[:score]]
        end

        def eager_product(hit)
          @product_ids ||= []
          @product_ids << hit['_id']
          hit
        end

        def fetch_product(id)
          @products ||= Spree::Product.where(id: @product_ids).to_a
          @products.find { |p| p.id == id.to_i }
        end

        def bucket_products(bucket)
          bucket.dig('products', 'hits', 'hits').map(&method(:eager_product)).lazy.map do |hit|
            fetch_product(hit['_id'])
          end
        end
      end
    end
  end
end

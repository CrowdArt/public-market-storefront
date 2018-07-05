module Spree
  module Inventory
    module Searchers
      class FindSimilarProducts < BaseSearcher
        param :product
        option :filter_by_variation, optional: true

        def call
          find_similar
        end

        private

        def find_similar
          where_filters = fields_to_match
          where_filters.merge!(required_fields)
          where_filters.merge!(filters)

          Spree::Product.search(
            '*',
            where: where_filters,
            misspellings: { edit_distance: 2 },
            load: false
          )
        end

        def fields_to_match
          {
            'name' => product.name,
            product.author_property_name => product.subtitle
          }
        end

        # https://www.elastic.co/guide/en/elasticsearch/reference/6.2/query-dsl-mlt-query.html
        # DISABLED
        def mlt_query
          return {} if (fields = mlt_fields).blank?
          {
            more_like_this: {
              fields: fields,
              like: [
                {
                  '_index': Spree::Product.search_index.name,
                  '_id': product.id
                }
              ],
              min_doc_freq: 1,
              min_term_freq: 1,
              include: true
            }
          }
        end

        def filters
          filter_by_variation ? { variations: filter_by_variation } : {}
        end

        def required_fields
          return {} if product.taxonomy.blank?
          taxonomy_field = "#{product.taxonomy.name.downcase}_ids"
          { taxonomy_field => { not: nil }}
        end

        def mlt_fields
          applicable_mlt_fields = product.taxonomy&.variation_module&.const_get('VariationFinder')&.mlt_fields
          product.properties.where(name: applicable_mlt_fields).pluck(:name)
        end
      end
    end
  end
end

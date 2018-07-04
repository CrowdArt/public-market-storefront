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
          must_query = [
            mlt_query.presence,
            required_fields.presence
          ].compact.concat(fields_to_match)

          Spree::Product.search(
            body: {
              query: {
                bool: {
                  must: must_query,
                  filter: filters
                }
              }
            },
            load: false
          )
        end

        def fields_to_match # rubocop:disable Metrics/MethodLength
          [
            {
              match: {
                'name.analyzed': {
                  query: product.name
                }
              }
            },
            {
              match: {
                "#{product.author_property_name}.analyzed" => {
                  query: product.subtitle
                }
              }
            }
          ]
        end

        # https://www.elastic.co/guide/en/elasticsearch/reference/6.2/query-dsl-mlt-query.html
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
          { term: { variations: filter_by_variation }} if filter_by_variation
        end

        def required_fields
          return if product_taxonomy.blank?
          taxonomy_field = "#{product.taxonomy.name.downcase}_ids"
          { exists: { field: taxonomy_field }}
        end

        def product_taxonomy
          product.taxonomy
        end

        def mlt_fields
          applicable_mlt_fields = product_taxonomy&.variation_module&.const_get('VariationFinder')&.mlt_fields
          product.properties.where(name: applicable_mlt_fields).pluck(:name)
        end
      end
    end
  end
end

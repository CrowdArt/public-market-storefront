module Spree
  module Inventory
    module Searchers
      class ProductSearcher < BaseSearcher
        option :current_user, optional: true
        option :filter, optional: true
        option :sort, optional: true
        option :taxon_ids, optional: true
        option :enable_aggs, optional: true, default: proc { false }
        option :includes, optional: true, default: proc { [:tax_category, :best_variant, master: %i[default_price prices images]] }
        option :operator, optional: true, default: proc { :or }

        def call
          search_products
        end

        def retrieve_products
          search_products
        end

        private

        def prepare_body(body)
          return if keywords.blank?

          keyword_query = %i[query bool must dis_max]

          # function score is used with boosting enabled
          if (function_score = body.dig(:query, :function_score, *keyword_query)).present?
            function_score[:tie_breaker] = 1
          elsif (body_keyword_query = body.dig(*keyword_query)).present?
            body_keyword_query[:tie_breaker] = 1
          end
        end

        def where
          where_query = {
            active: true,
            in_stock: { gt: 0 },
            or: [],
            price: { gt: 0.3 }
          }
          where_query[:taxon_ids] = taxon_ids if taxon_ids
          where_query.merge(add_search_filters(where_query))
        end

        def aggs # rubocop:disable Metrics/MethodLength
          return unless enable_aggs

          aggregations = {
            variations: {
              terms: {
                field: :variations
              }
            }
          }

          Spree::Taxonomy.filterable.each do |taxonomy|
            field = taxonomy.filter_name.to_sym
            aggregations[field] = { terms: { field: field }}
          end

          Spree::Property.filterable.each do |property|
            field = property.filter_name.to_sym
            aggregations[field] = { terms: { field: field }}
          end

          aggregations
        end

        def add_search_filters(query)
          return query unless filter

          filter.symbolize_keys.each do |name, scope_attribute|
            query.merge!(Hash[name, scope_attribute])
          end

          query
        end

        def order
          return if sort.blank?

          [add_popularity_sort, add_price_sort].compact
        end

        def add_popularity_sort
          return if (sort_option = sort.symbolize_keys[:popularity]).blank?

          case sort_option
          when 'all_time'
            boost_factor_sort.merge(conversions: :desc)
          when 'month'
            boost_factor_sort.merge(conversions_month: :desc)
          end
        end

        ALLOWED_PRICE_ORDER = %w[asc desc].freeze
        def add_price_sort
          sort_option = sort.symbolize_keys[:price]
          return if sort_option.blank? || !ALLOWED_PRICE_ORDER.include?(sort_option)
          boost_factor_sort.merge(price: sort_option)
        end

        def boost_factor_sort
          { _script:
            { type: 'number',
              script: {
                lang: 'painless',
                source: "doc['boost_factor'].value > 0 ? 1 : 0"
              },
              order: 'desc' }}
        end

        def boost_by
          {
            boost_factor: { factor: 1, missing: 1, modifier: 'none' },
            conversions: { factor: 1, missing: 1, modifier: 'none' }
          }
        end
      end
    end
  end
end

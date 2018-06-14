module Spree
  module Inventory
    module Searchers
      class ProductSearcher < BaseSearcher
        option :current_user, optional: true
        option :filter, optional: true
        option :sort, optional: true
        option :taxon_ids, optional: true
        option :enable_aggs, optional: true, default: proc { false }

        def call
          search_products
        end

        def retrieve_products
          search_products
        end

        private

        def where
          where_query = {
            active: true,
            or: []
          }
          where_query[:taxon_ids] = taxon_ids if taxon_ids
          where_query.merge(add_search_filters(where_query))
        end

        def aggs # rubocop:disable Metrics/MethodLength
          return unless enable_aggs

          aggregations = {
            price_range: {
              range: price_ranges_agg
            },
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

        ALLOWED_WHERE_PARAMS = %w[format variations].freeze
        def add_search_filters(query)
          return query unless filter

          filter.select { |param, _val| ALLOWED_WHERE_PARAMS.include?(param) }.each do |name, scope_attribute|
            query.merge!(Hash[name, scope_attribute])
          end

          query.merge!(add_price_filter(query))

          query
        end

        ALLOWED_SORT_PARAMS = %i[conversions].freeze
        def order
          return if sort.blank?

          [add_popularity_sort].compact
        end

        def add_popularity_sort
          return if (sort_option = sort['popularity']).blank?

          case sort_option
          when 'all_time'
            { conversions: :desc }
          when 'month'
            { conversions_month: :desc }
          end
        end

        def add_price_filter(query) # rubocop:disable Metrics/AbcSize
          return {} if (price_ranges = filter['price']).blank?

          price_filters = []

          price_ranges.each do |price_range|
            matched_filter = fixed_price_ranges.find { |r| r[:key].to_s == price_range }
            next unless matched_filter
            price_filters << {
              price: {
                gt: matched_filter[:from],
                lt: matched_filter[:to]
              }.compact
            }
          end

          query[:or] << price_filters
          query
        end

        def price_ranges_agg
          {
            field: :price,
            ranges: fixed_price_ranges
          }
        end

        def fixed_price_ranges
          [
            { key: :to_5, to: 5 },
            { key: :from_5_to_10, from: 5, to: 10 },
            { key: :from_10_to_20, from: 10, to: 20 },
            { key: :from_20, from: 20 }
          ]
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

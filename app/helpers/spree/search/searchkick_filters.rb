module Spree
  module Search
    module SearchkickFilters
      def self.applicable_filters(aggregations) # rubocop:disable Metrics/MethodLength
        es_filters = []

        Spree::Property.filterable.each do |property|
          property_options = process_filter(:property, aggregations[property.filter_name])

          next if property_options.blank?

          es_filters << {
            name: property.filter_name,
            type: :property,
            options: property_options
          }
        end

        if (price_options = process_filter(:price, aggregations['price_range'])).present?
          es_filters << {
            name: 'Price',
            type: :price,
            options: price_options
          }
        end

        es_filters.uniq
      end

      def self.process_filter(type, filter)
        filter_method = "#{type}_filter"
        send("#{type}_filter", filter) if respond_to?(filter_method, include_private: true)
      end

      # show all filters in dev
      MIN_PRODUCTS_TO_FILTER = Rails.env.development? ? 0 : 20

      def self.property_filter(filter)
        filter['buckets'].reject { |b| b['doc_count'] < MIN_PRODUCTS_TO_FILTER }
                         .map do |h|
                           v = h['key']
                           { label: v, value: v, id: v.parameterize }
                         end
      end

      def self.price_filter(filter)
        filter['buckets'].reject { |b| b['doc_count'] < MIN_PRODUCTS_TO_FILTER }
                         .map do |h|
                           v = h['key']
                           { label: I18n.t("filters.price_ranges.#{v}"), value: v, id: v }
                         end
      end
    end
  end
end

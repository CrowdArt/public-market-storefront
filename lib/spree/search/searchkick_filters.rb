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
    end

    def self.process_filter(type, filter)
      filter_method = "#{type}_filter"
      send("#{type}_filter", filter) if respond_to?(filter_method, include_private: true)
    end

    def self.property_filter(filter)
      filters = filter['buckets'].map do |h|
        v = h['key']
        disabled = h['doc_count'].zero?
        { label: v, value: v, id: v.parameterize, disabled: disabled }
      end

      return if filters.count { |f| !f[:disabled] } <= 1 # don't show if 0 or 1 enabled options

      filters
    end

    def self.price_filters(aggs)
      return if (price_options = price_filter(aggs['price_range'])).blank?
      {
        name: 'Price',
        type: :price,
        options: price_options
      }
    end

    def self.price_filter(filter)
      filters = filter['buckets'].map do |h|
        v = h['key']
        disabled = h['doc_count'].zero?
        { label: I18n.t("filters.price_ranges.#{v}"), value: v, id: v, disabled: disabled }
      end

      return if filters.count { |f| !f[:disabled] } <= 1 # don't show if 0 or 1 enabled options

      filters
    end
  end
end

module Spree
  module Search
    module SearchkickFilters
      module_function

      def applicable_filters(taxon: nil)
        es_filters = []

        es_filters.concat(TaxonFilters.applicable_filters(taxon)) if taxon

        es_filters.uniq
      end

      def process_filter(type, filter = nil)
        filter_method = "#{type}_filter"
        send("#{type}_filter", filter) if respond_to?(filter_method, include_private: true)
      end
    end

    # Spree::Property.filterable.each do |property|
    #   property_options = process_filter(:property, aggregations[property.filter_name])

    #   next if property_options.blank?

    #   es_filters << {
    #     name: property.filter_name,
    #     type: :property,
    #     options: property_options
    #   }
    # end

    # def self.property_filter(filter)
    #   filters = filter['buckets'].map do |h|
    #     v = h['key']
    #     disabled = h['doc_count'].zero?
    #     { label: v, value: v, id: v.parameterize, disabled: disabled }
    #   end

    #   return if filters.count { |f| !f[:disabled] } <= 1 # don't show if 0 or 1 enabled options

    #   filters
    # end
  end
end

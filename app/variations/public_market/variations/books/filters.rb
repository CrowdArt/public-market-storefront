module PublicMarket
  module Variations
    module Books
      module Filters
        module_function

        def applicable_filters(aggregations)
          filters = []

          if (variation_options = book_format_filter(aggregations['variations'])).present?
            filters << {
              name: 'Format',
              type: :variations,
              options: variation_options
            }
          end

          filters
        end

        def book_format_filter(filter)
          Books::Properties.available_variations.map do |f|
            bucket = filter['buckets'].find { |b| b['key'] == f }
            disabled = bucket.blank? || bucket['doc_count'].zero?
            { label: f, value: f, id: f.parameterize, disabled: disabled }
          end
        end
      end
    end
  end
end

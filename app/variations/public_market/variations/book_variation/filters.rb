module PublicMarket
  module Variations
    module BookVariation
      class Filters
        class << self
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

          def book_format_filter(filter) # rubocop:disable Metrics/AbcSize
            BookVariation::Properties.book_format.keys.map do |f|
              bucket = filter['buckets'].find { |b| b['key'] == f }
              disabled = bucket.blank? || bucket['doc_count'].zero?
              { label: f, value: f, id: f.parameterize, disabled: disabled }
            end

            # return if filters.count { |f| !f[:disabled] } <= 1 # don't show if 0 or 1 enabled options

            # filters
          end
        end
      end
    end
  end
end

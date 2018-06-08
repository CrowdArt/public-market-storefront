module PublicMarket
  module Variations
    module BookVariation
      class Filters
        class << self
          def applicable_filters(aggregations, min_products)
            filters = []

            if (variation_options = book_format_filter(aggregations['variations'], min_products)).present?
              filters << {
                name: 'Format',
                type: :variations,
                options: variation_options
              }
            end

            filters
          end

          def book_format_filter(filter, min_products)
            formats = BookVariation::Properties.book_format.keys

            formats.reject do |k|
              bucket = filter['buckets'].find { |b| b['key'] == k }
              bucket.blank? || bucket['doc_count'] < min_products
            end.map do |f| # rubocop:disable Style/MultilineBlockChain
              { label: f, value: f, id: f.parameterize }
            end
          end
        end
      end
    end
  end
end

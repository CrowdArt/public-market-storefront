module PublicMarket
  module Variations
    module Music
      class Filters
        class << self
          def applicable_filters(aggregations)
            return [] if (variation_options = format_filter(aggregations['variations'])).blank?
            [{
              name: 'Format',
              type: :variations,
              options: variation_options
            }]
          end

          def format_filter(filter)
            %w[vinyl cd].map do |f|
              bucket = filter['buckets'].find { |b| b['key'] == f }
              disabled = bucket.blank? || bucket['doc_count'].zero?
              { label: f, value: f, id: f.parameterize, disabled: disabled }
            end
          end
        end
      end
    end
  end
end

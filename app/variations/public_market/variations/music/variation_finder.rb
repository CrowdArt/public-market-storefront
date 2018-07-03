module PublicMarket
  module Variations
    module Music
      class VariationFinder < BaseVariationFinder
        class << self
          def mlt_fields
            %i[vinyl_speed music_format music_label music_label_number]
          end

          def variation_name(format, variation)
            if format == 'vinyl'
              vinyl_speed = variation.respond_to?(:property) ? variation.property(:vinyl_speed) : variation[:vinyl_speed]
              format += " (#{vinyl_speed})" if vinyl_speed
            end

            format&.humanize
          end
        end
      end
    end
  end
end

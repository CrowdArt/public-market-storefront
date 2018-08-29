module PublicMarket
  module Variations
    module Music
      class Properties < Variations::Properties
        class << self
          def variation_properties(product)
            [product.property(:music_format)]
          end

          def filter_properties(product)
            variation_properties(product)
          end

          # Unique PM book format
          def variation(product)
            variation_properties(product).first
          end

          def filterable_variations
            available_variations
          end

          def available_variations
            %w[vinyl cd]
          end
        end
      end
    end
  end
end

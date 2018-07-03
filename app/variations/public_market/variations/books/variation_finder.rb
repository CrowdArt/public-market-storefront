module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        def self.mlt_fields
          %i[edition publisher language]
        end
      end
    end
  end
end

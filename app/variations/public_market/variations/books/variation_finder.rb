module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        def self.similar_fields
          %i[edition publisher format]
        end

        def self.date_fields
          %i[published_at]
        end
      end
    end
  end
end

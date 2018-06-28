module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        class << self
          def filter(where, product, previous_variation)
            where[:name] = product.name
            where[:author] = product.property('author')
            where[:variations] = { not: [product.search_variation] }
            where[:variations][:not] << previous_variation.search_variation if previous_variation
            where
          end
        end
      end
    end
  end
end

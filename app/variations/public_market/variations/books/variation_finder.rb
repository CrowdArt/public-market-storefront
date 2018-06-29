module PublicMarket
  module Variations
    module Books
      class VariationFinder < BaseVariationFinder
        class << self
          def filter(where, product)
            where[:name] = product.name
            where[:author] = product.property('author')
            where
          end
        end
      end
    end
  end
end

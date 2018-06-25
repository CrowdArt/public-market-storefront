module Spree
  module Inventory
    module Searchers
      class MinPrice < ProductSearcher
        private

        def aggs
          {
            minimum_price: {
              min: {
                field: :price
              }
            }
          }
        end

        def boost_by
          {}
        end
      end
    end
  end
end

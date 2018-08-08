module Spree
  module Inventory
    module Searchers
      class MinPrice < ProductSearcher
        option :load, optional: true, default: proc { false }
        option :limit, optional: true, default: proc { 60 } # #159509912
        option :sort, optional: true, default: proc { { popularity: 'all_time' } }
        option :select, optional: true, default: proc { %i[price] }

        def call
          search_products.min_by { |a| a[:price] }&.dig(:price)
        end
      end
    end
  end
end

module Spree
  module Inventory
    module Searchers
      class StaffPicks < ProductSearcher
        private

        def fields
          %i[boost_factor]
        end

        def where
          {
            active: true,
            price: { not: nil }
          }
        end

        def order
          {
            boost_factor: {
              order: :desc, unmapped_type: :integer
            }
          }
        end

        def includes
          [master: :prices]
        end
      end
    end
  end
end

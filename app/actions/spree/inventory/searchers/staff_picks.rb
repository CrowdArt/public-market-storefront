module Spree
  module Inventory
    module Searchers
      class StaffPicks < ProductSearcher
        option :includes, optional: true, default: proc { [master: %i[prices images]] }

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
      end
    end
  end
end

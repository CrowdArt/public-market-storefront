module Spree
  module Inventory
    module Searchers
      class StaffPicks < ProductSearcher
        option :includes, optional: true, default: proc { [master: %i[prices images]] }

        private

        def add_search_filters(query)
          super.merge(
            boost_factor: {
              gt: 1
            }
          )
        end

        def order
          if sort.present?
            super
          else
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
end

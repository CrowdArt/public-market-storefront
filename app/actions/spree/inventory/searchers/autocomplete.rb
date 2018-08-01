module Spree
  module Inventory
    module Searchers
      class Autocomplete < ProductSearcher
        option :includes, optional: true, default: proc { [master: %i[prices images]] }

        private

        # this results in 2 query
        # https://github.com/ankane/searchkick#misspellings
        def misspellings
          { below: 3 }
        end
      end
    end
  end
end

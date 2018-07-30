module Spree
  module Inventory
    module Searchers
      class Autocomplete < ProductSearcher
        option :includes, optional: true, default: proc { [master: %i[prices images]] }

        private

        def word_match
          :word_start
        end

        # this results in 2 query
        # https://github.com/ankane/searchkick#misspellings
        def misspellings
          { below: 3 }
        end
      end
    end
  end
end

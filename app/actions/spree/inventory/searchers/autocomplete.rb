module Spree
  module Inventory
    module Searchers
      class Autocomplete < ProductSearcher
        private

        def includes
          [master: %i[prices images]]
        end

        def fields
          %i[name author]
        end

        def word_match
          :word_start
        end

        def misspellings
          { below: 3 }
        end
      end
    end
  end
end

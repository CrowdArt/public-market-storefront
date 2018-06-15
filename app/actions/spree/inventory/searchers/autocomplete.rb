module Spree
  module Inventory
    module Searchers
      class Autocomplete < ProductSearcher
        option :includes, optional: true, default: proc { [master: %i[prices images]] }

        private

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

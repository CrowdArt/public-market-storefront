require 'dry-validation'

module Spree
  module Inventory
    module Providers
      module Books
        TAXONOMY = 'Books'.freeze

        class BwbVariantProvider < VariantProvider
          PERMITTED_CONDITIONS = [
            'New',
            'Used - Like New',
            'Used - Excellent',
            'Used - Very Good',
            'Used - Good',
            'Used - Acceptable',
            'Collectible - Like New',
            'Collectible - Very Good',
            'Collectible - Good',
            'Collectible - Acceptable'
          ].freeze

          protected

          def mapped_condition(condition)
            condition
          end
        end
      end
    end
  end
end

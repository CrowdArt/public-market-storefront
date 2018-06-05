module Spree
  module Inventory
    module Searchers
      class BaseSearcher < Spree::BaseAction
        def call
          raise 'Not Implemented'
        end

        def search_products
          Spree::Product.search(query, boost_by: boost_by, body_options: body_options, where: where)
        end

        protected

        def where
          nil
        end

        def query
          '*'
        end

        def boost_by
          {
            boost_factor: { factor: 1, missing: 1, modifier: 'none' },
            conversions: { factor: 1, missing: 1, modifier: 'none' }
          }
        end

        def body_options
          { size: 0, aggs: aggs } if aggs.present?
        end

        def aggs
          nil
        end
      end
    end
  end
end

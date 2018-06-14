module Spree
  module Inventory
    module Searchers
      class BaseSearcher < Spree::BaseAction
        attr_writer :keywords, :page, :per_page

        option :keywords, optional: true
        option :per_page, optional: true, default: proc { Spree::Config[:products_per_page] }
        option :page, optional: true, default: proc { 1 }
        option :smart_aggs, optional: true, default: proc { true }
        option :limit, optional: true, default: proc { nil }

        def call
          raise 'Not Implemented'
        end

        def search_products # rubocop:disable Metrics/MethodLength
          prepare_params

          Spree::Product.search(
            keywords,
            includes: includes,
            fields: fields,
            boost_by: boost_by,
            match: word_match,
            misspellings: misspellings,
            body_options: body_options,
            order: order,
            page: page,
            per_page: per_page,
            smart_aggs: smart_aggs,
            where: where,
            limit: limit
          )
        end

        private

        def prepare_params
          self.keywords = '*' if keywords.blank?

          self.per_page = per_page.to_i
          self.per_page = Spree::Config[:products_per_page] unless per_page.positive?

          self.page = [PublicMarket::MAX_PAGES, [page.to_i, 1].max].min
        end

        def fields
          Spree::Product.search_fields
        end

        def where
          nil
        end

        def boost_by
          nil
        end

        def body_options
          { size: 0, aggs: aggs } if aggs.present?
        end

        def aggs
          nil
        end

        def order
          nil
        end

        def includes
          nil
        end

        def word_match
          nil
        end

        def misspellings
          nil
        end
      end
    end
  end
end

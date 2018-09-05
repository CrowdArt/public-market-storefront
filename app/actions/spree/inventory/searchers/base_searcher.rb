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
        option :includes, optional: true, default: proc { nil }
        option :load, optional: true, default: proc { true }
        option :explain, optional: true, default: proc { false }
        option :select, optional: true
        option :fields, optional: true, default: proc { Spree::Product.search_fields }
        option :operator, optional: true, default: proc { nil }

        def call
          raise 'Not Implemented'
        end

        def search_products # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          prepare_params

          Spree::Product.search(
            keywords.presence || '*',
            includes: includes,
            select: select,
            fields: fields,
            operator: operator,
            boost_by: boost_by,
            match: word_match,
            misspellings: misspellings,
            body_options: body_options,
            order: order,
            page: page,
            per_page: per_page,
            smart_aggs: smart_aggs,
            where: where,
            limit: limit,
            load: load,
            explain: explain,
            &method(:prepare_body)
          )
        end

        private

        def prepare_params
          self.per_page = per_page.to_i
          self.per_page = Spree::Config[:products_per_page] unless per_page.positive?

          self.page = [PublicMarket::MAX_PAGES, [page.to_i, 1].max].min
        end

        def prepare_body(body)
          body
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

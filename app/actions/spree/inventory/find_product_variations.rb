module Spree
  module Inventory
    class FindProductVariations < Spree::BaseAction
      param :product

      def call
        # TODO: cache
        where = {}
        variation = filter_by_taxonomy(where)
        return [] if variation.nil?

        variation.filter(where, product)

        products = Spree::Product.search(
          '*',
          where: where,
          misspellings: { edit_distance: 2 },
          load: false,
          debug: false
        )

        variation.results(products.results, product)
      end

      private

      def filter_by_taxonomy(where)
        taxonomy = product.taxons.first&.taxonomy
        return if taxonomy.blank?

        where["#{taxonomy.name.downcase}_ids"] = { not: nil }
        taxonomy.name == 'Books' ? BookVariation : nil
      end

      class BookVariation
        class << self
          def filter(where, product)
            where[:name] = product.name
            where[:author] = product.property('author')
            where
          end

          def results(products, _product)
            groups = products.group_by { |p| p['format'] }.map do |k, v|
              { name: format_text(k), price: min_price(v), slug: v.first['slug'] }
            end
            groups.length < 2 ? [] : groups
          end

          def format_text(format)
            case format
            when 'Trade Cloth'
              'Hardcover'
            when 'Trade Paper'
              'Paperback'
            else
              format
            end
          end

          def min_price(products)
            products.map { |pp| pp['price'] }.min
          end
        end
      end
    end
  end
end

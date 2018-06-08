module PublicMarket
  module Variations
    module BookVariation
      class VariationFinder
        class << self
          def filter(where, product)
            where[:name] = product.name
            where[:author] = product.property('author')
            where
          end

          def results(products, _product)
            groups = products.group_by { |p| p['format'] }.map do |k, v|
              {
                name: BookVariation::Properties.find_book_format(k) || k,
                price: min_price(v),
                slug: v.first['slug'],
                ids: v.map(&:_id).map(&:to_i)
              }
            end
            groups.length < 2 ? [] : groups
          end

          def min_price(products)
            products.map { |pp| pp['price'] }.min
          end
        end
      end
    end
  end
end

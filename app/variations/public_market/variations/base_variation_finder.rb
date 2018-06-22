module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def filter(where, product)
          where[:name] = product.name
          where
        end

        def results(products, product) # rubocop:disable Metrics/AbcSize
          map_variations(products).group_by { |p| p['variations'] }.map do |k, v|
            # if current product is in this variation - select it
            # else select product with min price
            variation_product =
              if product.search_variations.include?(k)
                v.find { |var| var[:_id].to_i == product.id }
              else
                product_with_min_price(v)
              end
            {
              name: variation_name(k, variation_product),
              price: variation_product[:price],
              slug: variation_product[:slug],
              ids: v.map(&:_id).map(&:to_i)
            }
          end
        end

        def product_with_min_price(products)
          products.min_by { |prod| prod[:price] }
        end

        def map_variations(products)
          # allow to group by all variations
          products.flat_map do |p|
            p['variations'].map do |v|
              p['variations'] = v
              p
            end
          end
        end

        def variation_name(format, _variation)
          format.humanize
        end
      end
    end
  end
end

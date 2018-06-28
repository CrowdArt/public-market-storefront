module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def filter(where, product, _previous_variation = nil)
          where[:name] = product.name
          where
        end

        def results(products, product, previous_variation = nil)
          # variations from searchkick - does not include product, previous variation and its formats
          search_result_variations =
            flatten_variations(products).group_by { |p| p['variations'] }.map do |k, v|
              map_variation(k, v.min_by { |prod| prod[:price] })
            end

          # current product + previous product if any
          search_result_variations.concat(mapped_products(product, previous_variation))
        end

        def mapped_products(product, previous_variation)
          variations = [map_variation(product.search_variation, product)]
          variations << map_variation(previous_variation.search_variation, previous_variation) if previous_variation

          variations
        end

        def flatten_variations(products)
          # allow to group by all variations
          products.flat_map do |product|
            product['variations'].map do |v|
              new_prod = product.dup
              new_prod['variations'] = v
              new_prod
            end
          end
        end

        def variation_name(format, _variation)
          format&.humanize
        end

        def map_variation(variation, product)
          {
            name: variation_name(variation, product),
            variation: variation,
            price: product.respond_to?(:price) ? product.price : product[:price],
            slug: product[:slug],
            id: (product[:_id] || product[:id]).to_i
          }
        end
      end
    end
  end
end

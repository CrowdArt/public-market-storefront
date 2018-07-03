module PublicMarket
  module Variations
    class BaseVariationFinder
      class << self
        def mlt_fields
          %i[name]
        end

        def results(products, product, previous_variation = nil) # rubocop:disable Metrics/AbcSize
          flatten_variations(products).group_by { |p| p['variations'] }.map do |k, v|
            product_variation = v.find do |var|
              [product.id, previous_variation&.id].include?(var[:_id].to_i)
            end

            product_variation ||= v.min_by { |prod| prod[:price] }

            similar_variants = find_similar_variants(v.reject { |var| var[:_id] == product_variation[:_id] }.map(&:_id))

            map_variation(k, product_variation, similar_variants)
          end
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

        def map_variation(variation, product, similar_variants)
          {
            name: variation_name(variation, product),
            variation: variation,
            similar_variants: similar_variants,
            price: product.respond_to?(:price) ? product.price : product[:price],
            slug: product[:slug],
            id: (product[:_id] || product[:id]).to_i
          }
        end

        def find_similar_variants(ids)
          Spree::Variant.find_best_price_in_best_main_option
                        .where(spree_products: { id: ids })
                        .sort_by { |v| v.option_values.first&.position || 0 }
                        .group_by(&:main_option_value)
                        .map { |k, v| map_similar_variants(k, v) }
        end

        def map_similar_variants(option_value, variants)
          {
            option: option_value,
            size: variants.size,
            price: variants.min_by(&:price).price,
            variants: variants.sort_by(&:price)
          }
        end

        def variation_name(format, _variation)
          format&.titleize
        end
      end
    end
  end
end

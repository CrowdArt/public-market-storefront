module Spree
  module Inventory
    class FindProductVariations < Spree::BaseAction
      param :product
      param :previous_variation, optional: true
      option :filter_by_variation, optional: true, default: proc { nil }
      option :load_variants, optional: true, default: proc { false }

      def call
        products = Searchers::FindSimilarProducts.call(product, filter_by_variation: filter_by_variation)

        results(products.results)
      end

      private

      def results(products) # rubocop:disable Metrics/AbcSize
        flatten_variation_properties(products).group_by { |p| p['variations'] }.map do |k, v|
          # always select current product of previous product as variation
          product_variation = v.find do |var|
            [product.id, previous_variation&.id].include?(var[:_id].to_i)
          end

          # select product with min price as variation
          product_variation ||= v.min_by { |prod| prod[:price] }

          @variations = v.reject { |var| var[:_id] == product_variation[:_id] }

          map_variation(k, product_variation)
        end
      end

      def flatten_variation_properties(products)
        # allow to group by all variations
        products.flat_map do |product|
          product['variations'].map do |v|
            new_prod = product.dup
            new_prod['variations'] = v
            new_prod
          end
        end
      end

      def find_similar_variants # rubocop:disable Metrics/AbcSize
        Spree::Variant.find_best_price_in_option
                      .where(spree_products: { id: @variations.map(&:_id) })
                      .sort_by { |v| v.option_values.first&.position || 0 }
                      .group_by { |var| product.taxonomy&.variation_module&.const_get('Options')&.condition(var.main_option_value) }
                      .map { |k, v| map_similar_variants(k, v) }
      end

      def map_variation(variation, product)
        {
          name: variation_finder.variation_name(variation, product),
          variation: variation,
          similar_variants: find_similar_variants,
          price: product[:price],
          slug: product[:slug],
          id: product[:_id].to_i
        }
      end

      def map_similar_variants(option_value, variants)
        {
          option: option_value.titleize,
          size: variants.size,
          price: variants.min_by(&:price).price,
          variants: (map_variants(variants) if load_variants)
        }
      end

      # rubocop:disable Style/MultilineBlockChain
      def map_variants(variants)
        variants.map do |var|
          product_score = @variations.find { |variation| variation['_id'] == var.product_id.to_s }&.fetch('_score')
          { variant: var, score: product_score }
        end.sort_by { |v| [v[:variant].price, -v[:score]] } # price ASC, product score DESC
      end
      # rubocop:enable Style/MultilineBlockChain

      def variation_finder
        product.taxonomy&.variation_module&.const_get('VariationFinder')
      end
    end
  end
end

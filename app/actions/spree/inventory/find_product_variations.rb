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

          ids = v.map(&:_id)
          # don't show current product variant in variation box if it's only one existing
          ids = [] if ids.one? && ids[0] == product_variation[:_id]

          variants = find_similar_variants(ids)

          map_variation(k, product_variation, variants)
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

      def find_similar_variants(ids) # rubocop:disable Metrics/AbcSize
        return [] if ids.blank?

        variants = Spree::Variant.find_best_price_in_option
                                 .where(product_id: ids)
                                 .includes(:default_price)
        if load_variants
          variants.includes(:vendor, :product)
                  .sort_by(&:price)
        else
          variants.sort_by { |v| v.main_option&.position || 0 }
                  .group_by { |v| v.mapped_main_option_value(product.taxonomy&.name&.downcase) }
                  .map { |k, v| map_similar_variants(k, v) }
        end
      end

      def map_variation(variation, product, variants)
        {
          variation_name_presentation: variation_finder.variation_name(variation, product),
          variation_name: variation,
          similar_variants: variants,
          price: product[:price],
          slug: product[:slug],
          id: product[:_id].to_i
        }
      end

      def map_similar_variants(option_value, variants)
        {
          option_value: option_value.titleize,
          size: variants.size,
          price: variants.min_by(&:price).price
        }
      end

      def variation_finder
        product.taxonomy&.variation_module&.const_get('VariationFinder')
      end
    end
  end
end

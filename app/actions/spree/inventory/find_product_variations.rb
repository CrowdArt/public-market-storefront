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
            selectable_variations.include?(var[:_id].to_i)
          end

          # select product with min price as variation
          product_variation ||= v.min_by { |prod| prod[:price] }

          ids = v.map(&:_id)
          # don't show current product variant in variation box if it's only one existing and variation exists
          ids = [] if !k.nil? && ids.one? && ids[0] == product_variation[:_id]

          variants = find_similar_variants(ids, blank_variation: k.nil?)

          map_variation(k, product_variation, variants)
        end
      end

      def selectable_variations
        @selectable_variations ||= [product.id, previous_variation&.id]
      end

      def flatten_variation_properties(products)
        # allow to group by all variations
        products.flat_map do |product|
          if product['variations'].present?
            product['variations'].map do |v|
              new_prod = product.dup
              new_prod['variations'] = v
              new_prod
            end
          else
            # keep nil in array to show blank variation
            new_prod = product.dup
            new_prod['variations'] = nil
            [new_prod]
          end
        end
      end

      def find_similar_variants(ids, blank_variation: false)
        return [] if ids.blank?

        variants = Spree::Variant.where(is_master: false, product_id: ids).includes(:default_price)
        # find best variant for products if variation present
        variants = variants.find_best_price_in_option unless blank_variation

        if load_variants
          variants.includes(:vendor, :product)
                  .sort_by(&:price)
        else
          variants.sort_by { |v| v.main_option&.position || 0 }
                  .group_by(&:mapped_main_option_value)
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

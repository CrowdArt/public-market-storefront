module Spree
  module ProductsHelper
    def product_description(product)
      description =
        if Spree::Config[:show_raw_product_description]
          product.description
        else
          product.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
        end

      return Spree.t(:product_has_no_description) if description.blank?

      sanitized_description = sanitize(description, tags: %w[strong em a i p], attributes: %w[href])

      raw(sanitized_description) # rubocop:disable Rails/OutputSafety
    end

    def cache_key_for_product(product = @product, opts = {})
      (common_product_cache_keys + [product.cache_key] + opts.to_a).compact.join('/')
    end

    def product_variants(product = @product)
      variants = product.variants_including_master
                        .spree_base_scopes
                        .in_stock
                        .active(current_currency)
                        .includes(:option_values, :prices, :vendor)
                        .reorder('spree_option_values.position ASC, spree_prices.amount ASC')
                        .select('spree_prices.amount')
                        .group_by(&:main_option_type)
                        .map(&method(:prepare_buy_box_variants))

      @selected = variants.first
      @selected[:selected] = true if @selected.present?

      other_seller_variants = @other_seller_variants.group_by(&:main_option_type) if @other_seller_variants

      [variants, other_seller_variants]
    end

    private

    def prepare_buy_box_variants(option_variants) # rubocop:disable Metrics/AbcSize
      option_value = option_variants[0]
      variants = option_variants[1]
      selected_variant = variants.first

      median_price = Spree::Price.new(amount: variants.map(&:price).median, currency: current_currency)

      if spree_current_user&.admin?
        @other_seller_variants ||= []
        @other_seller_variants.concat(variants.reject { |v| v.vendor == selected_variant.vendor })
      end

      {
        option_value: option_value,
        variant: selected_variant,
        median_price: median_price.money
      }
    end
  end
end

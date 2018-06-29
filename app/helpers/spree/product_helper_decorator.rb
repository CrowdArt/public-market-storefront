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
      ([:v11] + common_product_cache_keys + [product.cache_key] + opts.to_a).compact.join('/')
    end

    def product_variants(product = @product)
      variants = product.variants_including_master
                        .spree_base_scopes
                        .in_stock
                        .active(current_currency)
                        .includes(:option_values, :prices, :vendor)
                        .reorder('spree_option_values.position ASC, spree_prices.amount ASC')
                        .select('spree_prices.amount')
                        .group_by(&:main_option_value)
                        .map(&method(:prepare_buy_box_variants))

      @selected = variants.first
      @selected[:selected] = true if @selected.present?

      other_seller_variants = @other_seller_variants.group_by(&:main_option_value) if @other_seller_variants

      [variants, other_seller_variants]
    end

    def property_value_format(property_name, value)
      case property_name
      when 'book_subject'
        value.split('; ', 2).first&.titleize
      when 'author'
        value
      else
        value
      end
    end

    def product_variations
      return if @product.variation_module.blank?

      variations = Spree::Inventory::FindProductVariations.call(@product, @previous_variation)

      # always use same variations order
      @product.variation_module::Properties.available_variations.map do |variation_name|
        variations.find { |var| var[:variation] == variation_name }
      end.compact
    end

    private

    def prepare_buy_box_variants(option_variants)
      option_value = option_variants[0]
      variants = option_variants[1]
      selected_variant = variants.first

      median_price = Spree::Price.new(amount: variants.map(&:price).median, currency: current_currency)

      @other_seller_variants ||= []
      @other_seller_variants.concat(variants.reject { |v| v.vendor == selected_variant.vendor })

      {
        option_value: option_value,
        variant: selected_variant,
        median_price: median_price.money
      }
    end
  end
end

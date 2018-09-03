module Spree
  module ProductsHelper
    def product_description(product)
      description = product.product_description

      return Spree.t(:product_has_no_description) if description.blank?

      sanitized_description = sanitize(description, tags: %w[strong em a i p], attributes: %w[href])

      raw(sanitized_description) # rubocop:disable Rails/OutputSafety
    end

    def product_subtitle(product)
      variation = product.variation_finder&.variation_name(product)
      product_date = Date.parse(product.product_date)&.strftime('%b %-d, %Y') if product.product_date
      [variation, product_date].compact.join(' — ')
    end

    def additional_product_note(product)
      variant = product.variants.find_by(is_master: false)
      t(product.product_kind_name, scope: 'products.additional_note',
                                   option_value: variant.main_option_value,
                                   note: product.description || variant.notes)
    end

    def cache_key_for_product(product = @product, opts = {})
      ([:v22, product.cache_key, product.rewards] + common_product_cache_keys + opts.to_a).compact.join('/')
    end

    def product_variants(product = @product, variant = @buy_box_variant)
      product.variants
             .spree_base_scopes
             .where.not(id: variant&.id)
             .in_stock
             .active(current_currency)
             .includes(:option_values, :prices, :vendor)
             .reorder('spree_option_values.position ASC, spree_prices.amount ASC')
             .group_by(&:main_option_value)
    end

    def property_value_format(property_name, value)
      case property_name
      when 'book_subject'
        value.split('; ', 2).first&.titleize
      when 'author'
        value
      when 'music_format'
        titleized_variation_name(value)
      else
        value
      end
    end

    def product_variations
      return if @product.variation_module.blank?

      variations = Spree::Inventory::FindProductVariations.call(@product, @previous_variation)

      # always use same variations order
      @product.variation_module::Properties.available_variations.map do |variation_name|
        variations.find { |var| var[:variation_name] == variation_name }
      end.compact
    end

    def product_kind_views_exists?(product, view)
      product.product_kind_name && lookup_context.exists?(product.product_kind_name, ["spree/products/#{view}"], true, [], formats: [:html])
    end
  end
end

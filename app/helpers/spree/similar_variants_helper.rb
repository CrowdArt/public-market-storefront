module Spree
  module SimilarVariantsHelper
    def similar_variants_cache_key
      [:v1, :similar_variants, @product, @variation, @variants, browser.device.mobile?]
    end

    def available_filter_options(variants, product) # rubocop:disable Metrics/AbcSize
      # child options with parent name are rejected
      opts = variants.sort_by { |v| v.main_option&.position || 0 }
                     .group_by { |v| v.mapped_main_option_value(product.taxonomy&.name&.downcase) }
                     .map { |k, v| [k, v.reject { |var| k.casecmp(var.main_option_value).zero? }.map(&:main_option_value).uniq] }

      # don't show filters if only 1 parent and 0-1 child options available
      return if opts.size == 1 && opts[0][1].size <= 1
      opts.to_h
    end

    def variant_data_options(variant)
      [variant.main_option_value.parameterize, variant.mapped_main_option_value(@product.taxonomy&.name&.downcase)].uniq.join(' ')
    end

    def additional_variation_property(variant)
      case @product.taxonomy&.name&.downcase
      when 'books'
        if (published_at = variant.product.property(:published_at)).present?
          published_at = published_at[0..3] # use year
        end

        [published_at, variant.product.property(:edition)].compact.join(': ')
      end
    end

    def variation_name(product_variation)
      t("variations.titleized-format.#{product_variation}", default: product_variation.titleize)
    end
  end
end

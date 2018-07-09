module Spree
  module SimilarVariantsHelper
    def available_filter_options
      @variants.group_by { |v| v.mapped_main_option_value(@product.taxonomy&.name&.downcase) }
               .map { |k, v| [k, v.reject { |var| k.casecmp(var.main_option_value).zero? }.map(&:main_option_value).uniq] }
               .to_h
    end

    def variant_data_options(variant)
      [variant.main_option_value.parameterize, variant.mapped_main_option_value(@product.taxonomy&.name&.downcase)].uniq.join(' ')
    end
  end
end

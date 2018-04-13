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
  end
end

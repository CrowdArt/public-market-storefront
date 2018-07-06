module PublicMarket
  module Variations
    module Books
      module Properties
        module_function

        def variation_properties(product)
          return if (formats = product.property(:format)).blank?
          format_variation =
            formats.split('; ').reject { |f| f.casecmp('other').zero? }.find do |format|
              mapped_format = find_book_format(format)
              break mapped_format if mapped_format
            end
          [format_variation || 'other']
        end

        def find_book_format(format)
          return if format.blank?
          book_formats.find { |_k, v| v.include?(format.downcase) }&.first
        end

        # ordered list
        def available_variations
          %w[hardcover paperback other]
        end

        def book_formats
          I18n.t('variations.formats.books').stringify_keys
        end
      end
    end
  end
end

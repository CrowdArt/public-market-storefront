module PublicMarket
  module Variations
    module Books
      class Properties < Variations::Properties
        class << self
          # filter format
          def variation_properties(product)
            return ['other'] if (formats = product.property(:format)).blank?

            child_formats = find_matching_format(formats.split('; '), book_formats)

            find_matching_format(child_formats, filterable_book_formats)
          end

          # Unique PM book format
          def variation(product)
            return 'other' if (formats = product.property(:format)).blank?

            find_matching_format(formats.split('; '), book_formats).first || 'other'
          end

          def find_matching_format(initial_formats, formats)
            return ['other'] if initial_formats.blank?

            matching_format =
              initial_formats.reject { |f| f.casecmp('other').zero? }.find do |format|
                mapped_format = find_book_format(formats, format)
                break mapped_format if mapped_format
              end

            [matching_format || 'other']
          end

          def find_book_format(formats, format)
            return if format.blank?
            formats.find { |_k, v| v.include?(format.downcase) }&.first
          end

          def filterable_variations
            filterable_book_formats.keys
          end

          # ordered list
          def available_variations
            I18n.t('variations.formats.books').stringify_keys.keys
          end

          def book_formats
            I18n.t('variations.formats.books').stringify_keys
          end

          def filterable_book_formats
            I18n.t('variations.filterable_formats.books').stringify_keys
          end
        end
      end
    end
  end
end

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
          book_format.find { |_k, v| v.include?(format.downcase) }&.first
        end

        def available_variations
          %w[hardcover paperback other]
        end

        def book_format # rubocop:disable Metrics/MethodLength
          {
            'hardcover' => [
              'hardcover',
              'trade cloth',
              'library binding',
              "children's board books"
            ],
            'paperback' => [
              'paperback',
              'trade paper',
              'mass market',
              'perfect',
              'digest paperback',
              'uk-a format paperback',
              'uk- a format paperback',
              'uk-b format paperback',
              'uk-trade paper'
            ],
            'other' => ['other']
          }
        end

        def subtitle(product)
          product.property(:author)
        end

        def additional_properties(product)
          [:edition].map { |p| product.property(p) }.compact
        end
      end
    end
  end
end

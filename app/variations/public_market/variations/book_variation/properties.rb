module PublicMarket
  module Variations
    module BookVariation
      class Properties
        class << self
          def variation_properties(product)
            return if (formats = product.property(:format)).blank?
            format_variation =
              formats.split('; ').reject { |f| f.casecmp('other').zero? }.find do |format|
                mapped_format = find_book_format(format)
                break mapped_format if mapped_format
              end
            [format_variation || 'Other']
          end

          def find_book_format(format)
            return if format.blank?
            book_format.find { |_k, v| v.include?(format.downcase) }&.first
          end

          def book_format # rubocop:disable Metrics/MethodLength
            {
              'Hardcover' => [
                'hardcover',
                'trade cloth',
                'library binding',
                "children's board books"
              ],
              'Paperback' => [
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
              'Other' => ['other']
            }
          end
        end
      end
    end
  end
end

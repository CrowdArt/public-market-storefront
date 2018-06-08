module PublicMarket
  module Variations
    module BookVariation
      class Properties
        class << self
          def variation_properties(product)
            [format(product)]
          end

          def format(product)
            format = product.property(:format)
            find_book_format(format) || format
          end

          def find_book_format(format)
            return if format.blank?
            book_format.find { |_k, v| v.include?(format.downcase) }&.first
          end

          def book_format
            {
              'Hardcover' => [
                'trade cloth',
                'library binding',
                "children's board books"

              ],
              'Paperback' => [
                'trade paper',
                'mass Market',
                'perfect',
                'digest paperback',
                'uk-b format paperback'
              ]
            }
          end
        end
      end
    end
  end
end

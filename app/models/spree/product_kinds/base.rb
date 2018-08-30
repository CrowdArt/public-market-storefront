module Spree
  module ProductKinds
    class Base
      extend Dry::Initializer

      param :product

      delegate :property, to: :product

      def subtitle
        return @subtitle if defined?(@subtitle)
        @subtitle = property(author_property_name)&.titleize
      end

      def image_aspect_ratio
        1
      end

      def additional_properties
        []
      end

      def author_property_name
        ''
      end

      def product_description
        product.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
      end

      def child_kind
        nil
      end

      def product_date
        nil
      end
    end
  end
end

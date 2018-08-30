module Spree
  module ProductKinds
    class Books < ProductKinds::Base
      def image_aspect_ratio
        2 / 3.to_f
      end

      def additional_properties
        [:edition].map { |p| property(p) }.compact
      end

      def author_property_name
        'author'
      end

      def product_date
        return @product_date if defined?(@product_date)
        @product_date = property(:published_at)
      end
    end
  end
end

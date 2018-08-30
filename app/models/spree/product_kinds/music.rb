module Spree
  module ProductKinds
    class Music < ProductKinds::Base
      def author_property_name
        'artist'
      end

      def child_kind
        @child_kind = property(:music_format)&.downcase
      end

      def product_description # rubocop:disable Metrics/AbcSize
        case child_kind
        when 'vinyl'
          opts = {
            genre: product.taxons.first.name,
            record_format: property(:music_format)&.titleize,
            rpm: property(:vinyl_speed)&.upcase,
            artist: subtitle,
            product_title: product.name,
            record_label: property(:music_label),
            catalog_number: property(:music_label_number)
          }

          I18n.t('products.description.vinyl', opts)
        else
          super
        end
      end
    end
  end
end

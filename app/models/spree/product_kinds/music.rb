module Spree
  module ProductKinds
    class Music < ProductKinds::Base
      def author_property_name
        'artist'
      end

      def child_kind
        @child_kind = property(:music_format)&.downcase
      end

      def product_description # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        case child_kind
        when 'vinyl'
          taxon_name = product.taxons.first.name
          opts = {
            genre: (taxon_name if taxon_name != Taxon::UNCATEGORIZED_NAME),
            record_format: property(:music_format)&.titleize,
            rpm: property(:vinyl_speed)&.upcase,
            artist: subtitle_presentation,
            product_title: product.name,
            record_label: property(:music_label),
            catalog_number: property(:music_label_number)
          }

          I18n.t('products.description.vinyl', opts)
        else
          super
        end
      end

      def products_by_subtitle
        Inventory::Searchers::ProductSearcher.call(
          limit: 10,
          taxon_ids: product.taxons.map(&:self_and_ancestors).flatten.uniq.map(&:id),
          filter: {
            :id => { not: product.id },
            author_property_name => subtitle
          }
        )
      end
    end
  end
end

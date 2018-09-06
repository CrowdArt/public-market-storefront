module Spree
  module Inventory
    module Providers
      class GenericMetadataProvider < Spree::BaseAction
        param :item_json

        def call
          {
            title: item_json.dig('title'),
            price: item_json.dig('price').to_f,
            description: item_json.dig('description'),
            properties: properties,
            taxons: taxons,
            images: images
          }.deep_merge(taxonomy_metadata)
        end

        protected

        def taxonomy_metadata
          case taxonomy_name
          when 'Books'
            Books::BowkerMetadataProvider.call(identifier).compact
          else
            {}
          end
        end

        def identifier
          @identifier ||= item_json.dig('product_id')
        end

        def properties
          {
            # artist: item_json.dig('artist'),
            # music_format: item_json.dig('format'),
            # music_label: item_json.dig('label'),
            # music_label_number: item_json.dig('label_number'),
            # vinyl_speed: item_json.dig('speed'),
            # music_genres: item_json.dig('genres')
          }
        end

        def taxonomy_name
          taxons.first
        end

        def taxons
          @taxons ||= array(item_json[:categories]).map(&:humanize)
        end

        def images
          @images ||= array(item_json[:images]).map do |image|
            image.is_a?(String) ? { url: image } : image
          end
        end

        private

        def array(array_or_string, separator = ',')
          array_or_string.is_a?(Array) ? array_or_string : array_or_string.to_s.split(separator)
        end
      end
    end
  end
end

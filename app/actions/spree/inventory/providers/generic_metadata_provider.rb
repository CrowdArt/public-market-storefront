module Spree
  module Inventory
    module Providers
      class GenericMetadataProvider < Spree::BaseAction
        param :item_json
        param :schema_fields
        option :taxonomy_name, optional: true

        def call
          {
            title: item_json.dig('title'),
            price: item_json.dig('price').to_f,
            description: item_json.dig('description'),
            properties: properties,
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
          result = {}
          (item_json.symbolize_keys.keys - schema_fields).each do |field|
            result[field] = item_json[field.to_s]
          end
          result
        end

        def images
          @images ||= array(item_json[:images]).map do |image|
            image.is_a?(String) ? { url: image } : image
          end
        end
      end
    end
  end
end

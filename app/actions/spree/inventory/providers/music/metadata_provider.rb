module Spree
  module Inventory
    module Providers
      module Music
        class MetadataProvider < Spree::BaseAction
          param :item_json

          def call
            {
              title: item_json.dig('title'),
              price: item_json.dig('price').to_f,
              description: item_json.dig('description'),
              properties: properties,
              taxons: taxons,
              images: images
            }
          end

          protected

          def properties
            {
              artist: item_json.dig('artist'),
              music_format: item_json.dig('format'),
              music_label: item_json.dig('label'),
              music_label_number: item_json.dig('label_number'),
              vinyl_speed: item_json.dig('speed')
            }
          end

          def taxons
            return [] if (genres = item_json.dig('genres')).blank?
            genres = genres.split('; ')
            genres.map(&:humanize)
          end

          def images
            item_json.dig('images').to_a.map do |url|
              { file: image(url), title: item_json.dig('title') }
            end
          end

          def image(url)
            response = HTTParty.get(url)
            return unless response.success?
            file = Tempfile.new(['music', item_json['sku']])
            file.binmode
            file << response.body
            file.flush # https://github.com/thoughtbot/paperclip/issues/1899
            file
          end
        end
      end
    end
  end
end

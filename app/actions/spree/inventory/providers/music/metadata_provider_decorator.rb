module Spree
  module Inventory
    module Providers
      module Music
        module MetadataProviderDecorator
          protected

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

        MetadataProvider.prepend(MetadataProviderDecorator)
      end
    end
  end
end

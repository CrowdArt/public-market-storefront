module Spree
  module Inventory
    module Providers
      module Books
        class BowkerMetadataProvider < Spree::BaseAction
          param :isbn

          def call
            details = product_details(isbn)
            product = details&.dig('result', 'item')
            return {} if product.blank?

            {
              title: product.dig('title'),
              price: product.dig('price').to_f,
              description: product.dig('annotation'),
              properties: properties(product),
              dimensions: dimensions(product),
              taxons: taxons(product),
              images: images(product)
            }
          end

          private

          def properties(product)
            {
              isbn: isbn,
              author: product.dig('author'),
              format: product.dig('binding')&.split('; ')&.uniq&.join('; '),
              publisher: product.dig('publisher'),
              published_at: date(product.dig('pubdate')),
              language: product.dig('currlanguage'),
              pages: product.dig('pagecount'),
              edition: product.dig('editiondesc'),
              book_subject: product.dig('subject')
            }
          end

          def date(str)
            Date.parse(str) if str.present?
          end

          def dimensions(product)
            size = product.dig('size')

            {
              weight: product.dig('weight').to_f,
              weight_unit: product.dig('weight').to_s.gsub(/\W|\d/, ''),
              height: size&.dig('height')&.to_f,
              width: size&.dig('width')&.to_f,
              depth: size&.dig('length')&.to_f
            }
          end

          def taxons(product)
            return [] if (subject = product.dig('subject')).blank?
            subject.split('; ')
                   .map { |s| s.split(' / ') }
          end

          def images(product)
            return [] if (img = image(isbn)).blank?
            [{ file: img, title: product.dig('title') }]
          end

          def creds
            { username: Rails.application.credentials.bowker_user, password: Rails.application.credentials.bowker_password }
          end

          def product_details(isbn)
            url = "https://bms.bowker.com/rest/books/isbn/#{isbn}?format=xml"
            result = HTTParty.get(url, basic_auth: creds).parsed_response
            item = result.dig('result', 'item')
            return if item.blank?

            detail_url = item.is_a?(Array) ? item[0]['details'] : item['details']

            return if detail_url.blank?

            HTTParty.get(detail_url, basic_auth: creds).parsed_response
          end

          def image(isbn)
            # save in file here because paperclip can't work with basic auth in url
            response = HTTParty.get("https://imageweb.bowker.com/rest/images/ean/#{isbn}?size=original", basic_auth: creds)
            return unless response.success? # bowker can return AccessDenied response with FreeCoverImage #157634247
            file = Tempfile.new(isbn)
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

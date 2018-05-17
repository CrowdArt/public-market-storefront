module Spree
  module Inventory
    module Providers
      class BowkerMetadataProvider < Spree::BaseAction
        param :isbn

        def call
          details = product_details(isbn)
          product = details&.dig('result', 'item')
          return if product.blank?

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
            format: product.dig('binding'),
            publisher: product.dig('publisher'),
            published_at: date(product.dig('pubdate')),
            language: product.dig('currlanguage'),
            pages: product.dig('pagecount'),
            edition: product.dig('editiondesc')
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
          subjects = subject.split('; ')
          subjects.reject { |s| s.include?('(') }
                  .map { |s| s.split(' / ') }
                  .max_by(&:length)
                  .map(&:humanize)
        end

        def images(product)
          [{ file: image(isbn), title: product.dig('title') }]
        end

        def creds
          { username: Settings.bowker_user, password: Settings.bowker_password }
        end

        def product_details(isbn)
          url = "https://bms.bowker.com/rest/books/isbn/#{isbn}?fields=all&format=xml"
          result = HTTParty.get(url, basic_auth: creds).parsed_response
          detail_url = result.dig('result', 'item', 'details')
          return if detail_url.blank?

          HTTParty.get(detail_url, basic_auth: creds).parsed_response
        end

        def image(isbn)
          file = Tempfile.new(isbn)
          file.binmode
          file << HTTParty.get("https://imageweb.bowker.com/rest/images/ean/#{isbn}?size=original",
                               basic_auth: creds).body
          file
        end
      end
    end
  end
end

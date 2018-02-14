module Spree
  module Inventory
    module Providers
      class BtolMetadataProvider < Spree::BaseAction
        param :isbn

        def call
          item = btol_item(isbn)
          product_item = item&.dig('ProductItems', 'ProductItem')
          product = [product_item].flatten.first # can return array of products
          return if product.blank?

          parse_metadata(product).merge(description: select_description(item))
        end

        protected

        class Btol
          include HTTParty
          headers 'SOAPAction' => 'http://ContentCafe2.btol.com/XmlString', 'content-type' => 'text/xml'

          if Rails.env.development? || Rails.env.test?
            ProxyFetcher.config.provider = :free_proxy_list

            url = ProxyFetcher::Manager.new.proxies
                                       .select { |m| m.country == 'United States' && m.type == 'HTTP' }
                                       .first.url
            ENV['http_proxy'] = "http://#{url}"
          end
        end

        HTTParty::Parser.class_eval do
          def xml
            MultiXml.parse(body.gsub(/&#[^;]+;/, '')) # remove bad xml symbols
          end
        end

        def parse_metadata(product)
          title = content('Title', product)

          {
            title: title,
            images: [{ url: btol_image_url(isbn), title: title }],
            price: product.dig('ListPrice').to_f,
            properties: {
              isbn: isbn,
              author: product.dig('Author'),
              format: content('Format', product),
              publisher: content('Supplier', product),
              published_at: published(product),
              subject: product.dig('GeneralSubject'),
              grade_level: content('RatingGradeLevel', product)
            },
            dimensions: {
              weight: product.dig('Weight').to_f,
              height: product.dig('Height').to_f,
              width: product.dig('Width').to_f,
              depth: product.dig('Depth').to_f
            }
          }
        end

        def select_description(item)
          annotations = item.dig('AnnotationItems', 'AnnotationItem')
          return if annotations.blank?
          [annotations].flatten.map { |a| a.dig('Annotation') }.max_by(&:length)
        end

        def content(key, source)
          c = source[key]
          c.is_a?(Hash) ? c['__content__'] : c
        end

        def published(product)
          pub_date = product.dig('PubDate')
          Date.parse(pub_date) if pub_date.present?
        end

        def btol_item(isbn)
          Rails.logger.info("Request #{isbn} from B&T")

          request = btol_soap_request(isbn)
          result = Btol.post('http://contentcafe2.btol.com/contentcafe/contentcafe.asmx', body: request.delete("\n")).parsed_response
          return if result.blank?
          items = result.dig('Envelope', 'Body', 'XmlStringResponse', 'ContentCafe', 'RequestItems', 'RequestItem')
        end

        def btol_image_url(isbn)
          "http://images.btol.com/ContentCafe/Jacket.aspx?UserID=#{Settings.btol_user}&Password=#{Settings.btol_password}&Size=L&Value=#{isbn}"
        end

        def btol_soap_request(isbn)
          %(
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ContentCafe2.btol.com">
  <SOAP-ENV:Body>
    <ns1:XmlString>
      <ns1:xmlRequest>#{btol_request(isbn)}</ns1:xmlRequest>
    </ns1:XmlString>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
          )
        end

        def btol_request(isbn)
          request = %(
<ContentCafe xmlns="http://ContentCafe2.btol.com">
<RequestItems UserID="#{Settings.btol_user}" Password="#{Settings.btol_password}">
<RequestItem>
<Key Type="ISBN">#{isbn}</Key>
<Content>ProductDetail</Content>
<Content>AnnotationDetail</Content>
</RequestItem>
</RequestItems>
</ContentCafe>)
          CGI.escapeHTML(request)
        end
      end
    end
  end
end

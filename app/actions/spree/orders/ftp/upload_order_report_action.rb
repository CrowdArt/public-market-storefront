module Spree
  module Orders
    module Ftp
      class UploadOrderReportAction < Spree::BaseAction
        param :vendor
        param :ftp_key
        option :skip_ftp_upload, optional: true

        def call
          orders = FetchVendorOrdersAction.call(vendor)
          return if orders.blank?

          csv_file = create_report(orders)
          upload_to_ftp(csv_file)
        end

        private

        HEADERS = %i[OrderDate AbePoid AbeItemId VendorItemId Isbn Author Title Price Shipping BuyerEmailAddress
                     ShipToName ShipToAddress ShipToAddress2 ShipToCity ShipToProvState ShipToCountry
                     ShipToZipCode ShippingSpeed SpecialInstructions].freeze

        def create_report(orders)
          file = Tempfile.new('orders')

          CSV.open(file, 'wb', col_sep: "\t", headers: HEADERS, force_quotes: false, write_headers: true) do |csv|
            orders.each do |order|
              vendor_view = VendorView.new(order, vendor)
              vendor_view.line_items.each do |line_item|
                line_item.inventory_units.each do |unit|
                  csv << order_unit_row(order, unit)
                end
              end
            end
          end
          file
        end

        def order_unit_row(order, unit)
          {
            OrderDate: completed_at(order),
            AbePoid: order.hash_id,
            AbeItemId: unit.hash_id,
            VendorItemId: unit.variant.sku,
            Isbn: isbn(unit),
            Author: author(unit),
            Price: price(unit),
            Shipping: shipping_cost(unit),
            Title: unit.variant.name,
            BuyerEmailAddress: order.email,
            ShippingSpeed: 'Ships within: 5-8 days'
          }.merge(shipping_fields(order.ship_address))
        end

        def shipping_fields(address)
          {
            ShipToName: address.full_name,
            ShipToAddress: address.address1,
            ShipToAddress2: address.address2,
            ShipToCity: address.city,
            ShipToProvState: address.state_name,
            ShipToCountry: address.country.iso3,
            ShipToZipCode: address.zipcode
          }
        end

        def completed_at(order)
          order.completed_at.strftime('%F %T')
        end

        def isbn(unit)
          unit.variant.product.property('isbn')
        end

        def author(unit)
          unit.variant.product.property('author')
        end

        def price(unit)
          unit.line_item.display_price.money.format(symbol: false)
        end

        def shipping_cost(unit)
          unit.shipment.display_amount.money.format(symbol: false)
        end

        def upload_to_ftp(csv_file)
          return csv_file if skip_ftp_upload

          ftp = PublicMarket::FTP.new(ftp_key, debug: true)
          ftp.mkdir('Orders')
          ftp.put(csv_file, "Orders/orders-#{Time.current.to_i}.txt")
          ftp.close
          csv_file
        end
      end
    end
  end
end

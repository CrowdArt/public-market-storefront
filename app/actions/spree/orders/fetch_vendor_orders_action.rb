module Spree
  module Orders
    class FetchVendorOrdersAction < Spree::BaseAction
      param :vendor
      param :from_timestamp, optional: true

      def call
        fetch_vendor_orders
      end

      private

      def fetch_vendor_orders
        orders = Order.joins(line_items: :variant)
                      .includes(:shipments, line_items: %i[variant inventory_units],
                                            ship_address: %i[country state])
                      .complete
                      .where(spree_variants: { vendor_id: vendor.id })
                      .where(payment_state: :balance_due)
                      .where(shipment_state: %i[pending ready])
                      .order('spree_orders.updated_at DESC')
                      .distinct

        orders = orders.where('spree_orders.updated_at > ?', from_timestamp) if from_timestamp
        vendor_view(orders)
      end

      def vendor_view(orders)
        orders.map { |o| VendorView.new(o, vendor) }
      end
    end
  end
end

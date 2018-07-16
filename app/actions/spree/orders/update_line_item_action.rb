module Spree
  module Orders
    class UpdateLineItemAction
      attr_accessor :options

      def initialize(options)
        self.options = options.deep_dup
      end

      def call
        item = LineItem.find_by_hash_id(item_number)
        return { item_number => 'Not found' } if item.blank? || item.order.number != order_number

        perform_action(item)

        { item_number => item.state }
      end

      private

      def item_number
        options[:item_number]
      end

      def order_number
        options[:order_number]
      end

      def tracking_number
        options[:tracking_number]
      end

      def shipped_at
        options[:shipped_at].to_i
      end

      def perform_action(item)
        case options[:action]
        when 'cancel'
          item.cancel!
        when 'confirm'
          item.confirm!
        when 'ship'
          ship_shipment(item)
        end
      end

      def ship_shipment(item)
        item.confirm! unless item.confirmed?
        item.shipment.ship! unless item.shipment.shipped?
        item.shipment.update(tracking: tracking_number) if tracking_number.present?
        item.shipment.update(shipped_at: Time.zone.at(shipped_at)) if shipped_at.positive?
      end
    end
  end
end

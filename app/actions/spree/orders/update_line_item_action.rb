module Spree
  module Orders
    class UpdateLineItemAction
      attr_accessor :options

      def initialize(options)
        self.options = options.deep_dup
      end

      def call
        unit = InventoryUnit.find_by_hash_id(item_number)
        return { item_number => 'Not found' } if unit.blank? || !check_order(unit)

        perform_action(unit)

        { item_number => unit.state }
      end

      private

      def check_order(unit)
        options[:order_number] == unit.order.number || options[:order_id] == unit.order.hash_id
      end

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

      def perform_action(unit)
        case options[:action]
        when 'cancel'
          cancel_unit(unit)
        when 'confirm', 'ship'
          ship_unit(unit)
        end
      end

      def cancel_unit(unit)
        unit.cancel!
      end

      def ship_unit(unit)
        unit.ship! unless unit.shipped?

        ship_shipment(unit.shipment)
      end

      def ship_shipment(shipment)
        shipment.update(tracking: tracking_number) if tracking_number.present?
        return unless shipped_at.positive?

        shipment.ship! unless shipment.shipped?
        shipment.update(shipped_at: Time.zone.at(shipped_at))
      end
    end
  end
end

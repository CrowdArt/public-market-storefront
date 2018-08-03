module Spree
  module Orders
    class UpdateLineItemAction
      attr_accessor :options

      def initialize(options)
        self.options = options.deep_dup
      end

      def call
        if item_number.present?
          update_inventory_unit
        elsif sku.present?
          update_line_item
        end
      end

      private

      def update_inventory_unit
        unit = InventoryUnit.find_by_hash_id(item_number)
        return { item_number => 'Not found' } if unit.blank? || !check_order(unit)

        perform_action(unit)

        { item_number => unit.state }
      end

      def update_line_item
        line_item = LineItem.joins(:order, :variant)
                            .where(spree_orders: { number: order_number })
                            .where(spree_variants: { sku: sku }).first
        return { sku => 'Not found' } if line_item.blank?

        line_item.inventory_units.each(&method(:perform_action))

        { sku => line_item.inventory_units.first.state }
      end

      def check_order(unit)
        options[:order_number] == unit.order.number || options[:order_id] == unit.order.hash_id
      end

      def item_number
        options[:item_number]
      end

      def sku
        options[:sku]
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

        update_tracking(unit.shipment)
        ship_shipment(unit.shipment)
      end

      def update_tracking(shipment)
        shipment.update(tracking: tracking_number) if tracking_number.present? && shipment.tracking.blank?
      end

      def ship_shipment(shipment)
        return unless shipped_at.positive?

        shipment.ship! unless shipment.shipped?
        shipment.update(shipped_at: Time.zone.at(shipped_at))
      end
    end
  end
end

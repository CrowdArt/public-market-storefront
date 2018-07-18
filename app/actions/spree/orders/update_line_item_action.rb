module Spree
  module Orders
    class UpdateLineItemAction
      attr_accessor :options

      def initialize(options)
        self.options = options.deep_dup
      end

      def call
        item = LineItem.find_by_hash_id(item_number)
        return { item_number => 'Not found' } if item.blank? || !check_order(item)

        perform_action(item)

        { item_number => item.state }
      end

      private

      def check_order(item)
        options[:order_number] == item.order.number || options[:order_id] == item.order.hash_id
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

      def perform_action(item)
        case options[:action]
        when 'cancel'
          cancel_item(item)
        when 'confirm'
          confirm_item(item)
        end
      end

      def cancel_item(item)
        item.cancel!
      end

      def confirm_item(item)
        item.confirm!
        item.shipment.update(tracking: tracking_number) if tracking_number.present?
        return unless shipped_at.positive?

        item.shipment.ship! unless item.shipment.shipped?
        item.shipment.update(shipped_at: Time.zone.at(shipped_at))
      end
    end
  end
end

module Spree
  module Payments
    class CapturePaymentsAction < Spree::BaseAction
      def call
        Spree::Payment.pending.includes(order: :line_items).each(&method(:capture_payment))
      end

      private

      def capture_payment(payment)
        units = payment.order.inventory_units.to_a
        force_cancel(units) if payment.created_at < 5.days.ago

        payment.capture! if can_capture?(units)
      end

      def can_capture?(units)
        units.none?(&:ordered?) && units.any?(&:shipped?)
      end

      def force_cancel(units)
        units.select(&:ordered?).each(&:cancel!)
      end
    end
  end
end

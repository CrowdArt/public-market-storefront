module Spree
  module Payments
    class CapturePaymentsAction < Spree::BaseAction
      def call
        Spree::Payment.pending.includes(order: :line_items).each(&method(:capture_payment))
      end

      private

      def capture_payment(payment)
        items = payment.order.line_items.to_a
        force_cancel(items) if payment.created_at < 5.days.ago

        payment.capture! if can_capture?(items)
      end

      def can_capture?(items)
        items.none?(&:ordered?) && items.any?(&:confirmed?)
      end

      def force_cancel(items)
        items.select(&:ordered?).each(&:cancel!)
      end
    end
  end
end

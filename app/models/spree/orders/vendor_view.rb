module Spree
  module Orders
    class VendorView
      attr_accessor :order, :vendor

      def initialize(order, vendor)
        @order = order
        @vendor = vendor
      end

      include NumberAsParam

      delegate :payments, :state, :checkout_steps, :completed?, :payment_state,
               :completed_at, :approved?, :canceled?, :approved_at, :canceled_at,
               :canceler, :approver, :billing_address, :refresh_shipment_rates,
               :number, :errors, :considered_risky?, :special_instructions,
               :adjustments, :bill_address, :ship_address, :user, :model_name,
               :to_key, :cart?, :user_id, :outstanding_balance?, :outstanding_balance,
               :display_outstanding_balance, :email, :shipping_address, :hash_id, :channel,
               :shipping_eq_billing_address?, :is_risky?,
               to: :order

      extend Spree::DisplayMoney
      money_methods :item_total, :ship_total, :included_tax_total, :additional_tax_total,
                    :adjustment_total, :total

      def line_items
        order.line_items.joins(:variant).where(spree_variants: { vendor_id: @vendor })
      end

      def line_item_adjustments
        order.line_item_adjustments
             .joins('inner join spree_variants on spree_line_items.variant_id = spree_variants.id')
             .where(spree_variants: { vendor_id: @vendor })
      end

      def shipments
        order.shipments.joins(:stock_location).where(spree_stock_locations: { vendor_id: @vendor })
      end

      def shipment_adjustments
        order.shipment_adjustments
             .joins('inner join spree_stock_locations on spree_shipments.stock_location_id = spree_stock_locations.id')
             .where(spree_stock_locations: { vendor_id: @vendor })
      end

      def item_total
        line_items.sum('price * quantity')
      end

      def ship_total
        shipments.sum(:cost)
      end

      def included_tax_total
        line_items.sum(:included_tax_total) + shipments.sum(:included_tax_total)
      end

      def additional_tax_total
        line_items.sum(:additional_tax_total) + shipments.sum(:additional_tax_total)
      end

      def adjustment_total
        line_items.sum(:adjustment_total) + shipments.sum(:adjustment_total)
      end

      def total
        item_total + ship_total + adjustment_total
      end

      def shipment_state
        shipments.first.state
      end

      def rewards_amount
        line_items.sum(&:rewards_amount)
      end
    end
  end
end

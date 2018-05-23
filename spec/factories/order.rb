FactoryBot.define do
  factory :order_with_vendor_items, parent: :order do
    bill_address
    ship_address

    transient do
      line_items_count 1
      shipment_cost 100
      shipping_method_filter Spree::ShippingMethod::DISPLAY_ON_FRONT_END
    end

    after(:create) do |order, evaluator|
      create_list(:line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price)
      order.line_items.reload

      order.create_proposed_shipments
    end

    factory :vendor_order_ready_to_ship do
      payment_state 'paid'
      shipment_state 'ready'

      after(:create) do |order|
        create(:payment, amount: order.total, order: order, state: 'completed')
        order.shipments.each do |shipment|
          shipment.inventory_units.update_all state: 'on_hand'
          shipment.update_column('state', 'ready')
        end
        order.reload
      end

      factory :shipped_vendor_order do
        after(:create) do |order|
          order.shipments.each do |shipment|
            shipment.inventory_units.update_all state: 'shipped'
            shipment.update_column('state', 'shipped')
          end
          order.update_column('shipment_state', 'shipped')
          order.reload
        end
      end
    end
  end
end

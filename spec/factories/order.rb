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
  end
end

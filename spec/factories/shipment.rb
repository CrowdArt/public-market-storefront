FactoryBot.define do
  factory :pm_shipment, parent: :shipment do
    order { create(:pm_order_with_line_items) }
  end
end

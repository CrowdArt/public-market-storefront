FactoryBot.modify do
  factory :shipment do
    order { create(:order_with_line_items) }
  end
end

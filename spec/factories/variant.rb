FactoryBot.modify do
  factory :base_variant do
    vendor
    cost_price { price }

    transient do
      count_on_hand 1
    end

    after :create do |variant, evaluator|
      variant.stock_items.last.set_count_on_hand(evaluator.count_on_hand) unless variant.is_master

      Spree::StockLocation.where(vendor_id: nil).destroy_all
    end
  end
end

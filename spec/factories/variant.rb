FactoryBot.modify do
  factory :base_variant do
    vendor { create(:vendor) }
    cost_price { price }
  end
end

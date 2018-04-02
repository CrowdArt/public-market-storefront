FactoryBot.modify do
  factory :base_shipping_method do
    vendor { create(:vendor) }
  end
end

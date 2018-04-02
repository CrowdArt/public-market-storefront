FactoryBot.modify do
  factory :base_variant do
    vendor { create(:vendor) }
  end
end

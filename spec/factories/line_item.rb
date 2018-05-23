FactoryBot.modify do
  factory :line_item do
    variant { create(:variant, product: product) }
  end
end

FactoryBot.define do
  factory :pm_order, parent: :order do
    user { create(:pm_user) }

    factory :pm_order_with_line_items, parent: :order_with_line_items do
      user { create(:pm_user) }
    end
  end
end

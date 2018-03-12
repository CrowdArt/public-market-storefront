FactoryBot.define do
  factory :vendor, class: Spree::Vendor do
    name { FFaker::Company.name }
    state :active
  end
end

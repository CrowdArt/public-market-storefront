FactoryBot.define do
  factory :vendor, class: Spree::Vendor do
    name { FFaker::Company.name }
    state :active

    after(:create) do |vendor|
      vendor.shipping_methods << create(:shipping_method, vendor: vendor) if vendor.shipping_methods.empty?
    end
  end
end

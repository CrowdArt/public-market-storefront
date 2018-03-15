vendor = Spree::Vendor.create!(
  name: Settings.test_seller_name,
  state: 'active',
  users: Spree::User.where(email: Settings.test_seller_user_name)
)

method = Spree::ShippingMethod.last
Spree::ShippingMethod.create!(
  name: method.name,
  display_on: 'both',
  admin_name: "seller_#{vendor.id}_free",
  code: "seller_#{vendor.id}_free",
  shipping_categories: method.shipping_categories,
  zones: method.zones,
  calculator: Rails.application.config.spree.calculators.shipping_methods.first.create!,
  vendor: vendor
)

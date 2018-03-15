category = Spree::ShippingCategory.create!(name: 'Default')

Spree::ShippingMethod.create!(
  name: 'Free Shipping (5 - 8 days)',
  display_on: 'both',
  admin_name: 'free',
  code: 'free',
  shipping_categories: [category],
  zones: [Spree::Zone.last],
  calculator: Rails.application.config.spree.calculators.shipping_methods.first.create!
)

module Spree
  module VendorDecorator
    def self.prepended(base)
      base.after_create :create_default_shipping_method
    end

    def final_rewards
      rewards || Spree::Config.rewards
    end

    private

    def create_default_shipping_method
      category = ShippingCategory.find_or_create_by(name: 'Default')
      name = "seller_#{id}_free"

      shipping_methods.create(
        name: Spree.t(:free_shipping),
        display_on: 'both',
        admin_name: name,
        code: name,
        shipping_categories: [category],
        zones: Spree::Zone.all,
        calculator_type: Rails.application.config.spree.calculators.shipping_methods.first.name
      )
    end
  end

  Vendor.prepend(VendorDecorator)
end

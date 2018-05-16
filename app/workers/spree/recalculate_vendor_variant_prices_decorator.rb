Spree::RecalculateVendorVariantPrices.class_eval do
  def perform(vendor_id)
    vendor = Spree::Vendor.find_by(id: vendor_id)

    return if vendor.blank?

    Spree::Product.skip_callback(:touch, :after, :touch_taxons)

    Searchkick.callbacks(:bulk) do
      vendor.variants.includes(:default_price).find_each(&:adjust_price!)
    end

    Spree::Product.set_callback(:touch, :after, :touch_taxons)
  end
end

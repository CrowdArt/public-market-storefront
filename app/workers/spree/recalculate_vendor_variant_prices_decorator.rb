Spree::RecalculateVendorVariantPrices.class_eval do
  def perform(vendor_id)
    vendor = Spree::Vendor.find_by(id: vendor_id)

    return if vendor.blank?

    Spree::Product.skip_callback(:touch, :after, :touch_taxons)

    Searchkick.callbacks(false) do
      vendor.variants
            .where(is_master: false)
            .includes(:default_price)
            .find_each(&:adjust_price!)
    end

    Spree::Product.set_callback(:touch, :after, :touch_taxons)
  end
end

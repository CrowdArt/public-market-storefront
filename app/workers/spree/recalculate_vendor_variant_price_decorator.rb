Spree::RecalculateVendorVariantPrice.class_eval do
  sidekiq_options unique: :until_executed,
                  queue: :recalculation

  def perform(variant_id)
    return if (variant = Spree::Variant.find_by(id: variant_id)).blank?

    Searchkick.callbacks(false) { variant.adjust_price! }
  end
end

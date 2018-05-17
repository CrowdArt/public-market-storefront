Spree::EnqueueVendorVariantPricesRecalculation.class_eval do
  sidekiq_options unique: :until_executed,
                  queue: :recalculation
end

# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.logo = 'logo/public_market_logo_white.svg'
end

Rails.application.config.after_initialize do |app|
  app.config.spree.stock_splitters << Spree::Stock::Splitter::VendorSplitter
end

Spree.user_class = 'Spree::User'

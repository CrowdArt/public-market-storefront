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
  config.logo = config.admin_interface_logo = 'logo/public_market_logo_white.svg'
  config.allow_guest_checkout = false
  config.address_requires_phone = false
  config.products_per_page = 24
  config.auto_capture_on_dispatch = false
end

Spree::AppConfiguration.class_eval do
  preference :rewards, :integer, default: 5
end

Rails.application.config.after_initialize do |app|
  app.config.spree.stock_splitters << Spree::Stock::Splitter::VendorSplitter
end

Rails.application.config.to_prepare do
  Spree::Config.searcher_class = Spree::Inventory::Searchers::ProductSearcher
end

Spree::Auth::Config[:signout_after_password_change] = false
Spree::Auth::Config[:confirmable] = true

Spree.user_class = 'Spree::User'
Spree.admin_path = '/dashboard'

Spree::PermittedAttributes.user_attributes.push(:first_name, :last_name)
Spree::PermittedAttributes.taxon_attributes.push(:hidden)

Spree::PermittedAttributes.source_attributes.push(
  :funding,
  :card_name,
  :use_shipping,
  address_attributes: Spree::PermittedAttributes.address_attributes
)

Spree::PermittedAttributes.vendor_attributes.push(:rewards)

FrontendConfig = Spree::FrontendConfiguration.new
FrontendConfig.coupon_codes_enabled = false

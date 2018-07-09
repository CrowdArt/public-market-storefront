# Be sure to restart your server when you modify this file.
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

assets_to_precompile = %w[
  foundation_emails
  error_pages
  ckeditor/*
  stripeForm
  phoneInput
  fbActions
  twiActions
  searchFilters
  searchFilterTags
  spree/frontend/similar_variants.sass
  similarVariants.js
  bootstrap-tagsinput/dist/bootstrap-tagsinput.css
  bootstrap-tagsinput/dist/bootstrap-tagsinput.js
  raven-js/dist/raven.js
]

Rails.application.config.assets.precompile += assets_to_precompile

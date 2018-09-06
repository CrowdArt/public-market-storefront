require 'dry-validation'

module Spree
  module Inventory
    module Providers
      class GenericVariantProvider < DefaultVariantProvider
        VALIDATION_SCHEMA =
          ::Dry::Validation.Schema do
            required(:sku).filled(:str?)
            required(:product_id).filled(:str?)
            required(:categories) { array? | str? }
            required(:quantity).filled(:int?)
            required(:price).filled(:decimal?)

            optional(:title).str?
            optional(:description).str?
            optional(:notes).str?
            optional(:option_types) { array? | str? }
            optional(:images) { array? | str? }
            optional(:rewards_percentage).int?
          end

        protected

        def find_metadata(_identifier)
          GenericMetadataProvider.call(item_json.stringify_keys)
        end
      end
    end
  end
end

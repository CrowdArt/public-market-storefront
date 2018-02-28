module Spree
  module Inventory
    module Providers
      module UpdateVariantSellerDecorator
        def update_variant_hook(variant, item)
          variant.seller = item[:seller]
          super
        end
      end
    end
  end
end

Spree::Inventory::Providers::DefaultVariantProvider.prepend(Spree::Inventory::Providers::UpdateVariantSellerDecorator)

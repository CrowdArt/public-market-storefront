module Spree
  module Inventory
    module Providers
      module Books
        module VariantProviderDecorator
          protected

          def metadata_provider
            BowkerMetadataProvider
          end
        end

        VariantProvider.prepend(VariantProviderDecorator)
      end
    end
  end
end

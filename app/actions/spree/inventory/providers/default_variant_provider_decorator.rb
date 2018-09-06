module Spree
  module Inventory
    module Providers
      module DefaultVariantProviderDecorator
        protected

        def update_variant_hook(variant, item)
          variant.seller = item[:seller]
          super
        end

        def categorize(product, taxons)
          taxonomy = Spree::Taxonomy.create_with(filterable: true).find_or_create_by!(name: taxonomy_name)
          classifier.call(product, taxons || [], taxonomy: taxonomy)
        end

        def metadata_provider
          self.class.parent::MetadataProvider
        end

        def classifier
          DefaultClassifier
        end
      end

      DefaultVariantProvider.prepend(DefaultVariantProviderDecorator)
    end
  end
end

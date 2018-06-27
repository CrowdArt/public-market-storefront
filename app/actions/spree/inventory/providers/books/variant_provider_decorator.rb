module Spree
  module Inventory
    module Providers
      module Books
        module VariantProviderDecorator
          protected

          def metadata_provider
            BowkerMetadataProvider
          end

          def taxonomy_name
            'Books'
          end

          def categorize(product, taxon_candidates)
            taxonomy = Spree::Taxonomy.create_with(filterable: true).find_or_create_by!(name: taxonomy_name)
            Books::Classifier.call(product, taxonomy, taxon_candidates)
          end
        end

        VariantProvider.prepend(VariantProviderDecorator)
      end
    end
  end
end

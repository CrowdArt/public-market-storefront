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
          # created with filterable by default
          taxonomy = Spree::Taxonomy.create_with(filterable: true)
                                    .find_or_create_by!(name: taxonomy_name)

          parent_taxon = taxonomy.root
          taxons.each do |taxon|
            parent_taxon = parent_taxon.children.find_or_create_by!(name: taxon, taxonomy: taxonomy)
          end
          parent_taxon.products << product
        end
      end
    end
  end
end

Spree::Inventory::Providers::DefaultVariantProvider.prepend(Spree::Inventory::Providers::DefaultVariantProviderDecorator)

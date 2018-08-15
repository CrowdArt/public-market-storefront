module Spree
  module Inventory
    module Providers
      class DefaultClassifier < Spree::BaseAction
        param :product
        param :taxonomy
        param :taxon_candidates

        def call
          categorise
        end

        private

        def categorise # rubocop:disable Metrics/AbcSize
          parent_taxon = taxonomy.root
          taxon_candidates.each do |taxon|
            parent_taxon = parent_taxon.children.find_by(name: taxon)
          end

          if parent_taxon.present?
            parent_taxon.products << product
          else
            uncategorized_taxon = taxonomy.uncategorized_taxon
            uncategorized_taxon.products << product unless product.taxons.include?(uncategorized_taxon)
          end
        end

        def find_taxon(parent_taxon, taxon)
          # match using ILIKE to make match case-insensitive
          parent_taxon.children.find_by('name ILIKE ?', taxon)
        end
      end
    end
  end
end

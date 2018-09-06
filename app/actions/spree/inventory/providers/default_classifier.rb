module Spree
  module Inventory
    module Providers
      class DefaultClassifier < Spree::BaseAction
        param :product
        param :taxon_candidates, optional: true, default: proc { [] }
        option :taxonomy, optional: true, default: proc { Taxonomy.other }

        def call
          categorise
        end

        private

        def categorise # rubocop:disable Metrics/AbcSize
          parent_taxon = taxonomy.root

          taxon_candidates.each do |taxon|
            new_parent_candidate = find_taxon(parent_taxon, taxon)
            # save last matched taxon as parent
            new_parent_candidate.blank? ? break : parent_taxon = new_parent_candidate
          end

          # save to uncategorized if root taxon found
          if parent_taxon.present? && parent_taxon != taxonomy.root
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

module Spree
  module Inventory
    module Providers
      module Books
        class Classifier < Spree::BaseAction
          param :product
          param :taxonomy
          param :taxon_candidates

          def call
            categorise
          end

          private

          def categorise
            matching_taxons = taxon_candidates.map(&method(:map_taxon_candidates))
                                              .compact
                                              .uniq

            # drop parent taxons if any of matches are childs
            matching_taxons = matching_taxons.reject do |taxon|
              matching_taxons.any? { |b| b != taxon && b.ancestors.find_by(id: taxon.id).present? }
            end

            assign_to_taxons(matching_taxons)
          end

          def map_taxon_candidates(taxons)
            parent_taxon = taxonomy.root
            # drop General to put products in General in root
            taxons.reject { |taxon| taxon == 'General' }.each do |taxon|
              new_parent_candidate = find_taxon(parent_taxon, taxon)
              # save last matched taxon as parent
              new_parent_candidate.present? ? parent_taxon = new_parent_candidate : break
            end

            parent_taxon if parent_taxon != taxonomy.root # disallow saving to taxonomy root
          end

          def find_taxon(parent_taxon, taxon)
            # match using ILIKE to make match case-insensitive
            parent_taxon.children.find_by('name ILIKE ?', taxon)
          end

          def assign_to_taxons(matching_taxons) # rubocop:disable Metrics/AbcSize
            if matching_taxons.any?
              matching_taxons.each do |taxon|
                next if product.taxons.include?(taxon)
                taxon.products << product
              end
            else
              uncategorized_taxon = taxonomy.uncategorized_taxon
              uncategorized_taxon.products << product unless product.taxons.include?(uncategorized_taxon)
            end
          end
        end
      end
    end
  end
end

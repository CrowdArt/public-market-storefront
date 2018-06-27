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

          protected

          def categorise # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
            matching_taxons = taxon_candidates.map do |taxons|
              parent_taxon = taxonomy.root
              # put products in General to root
              taxons.reject { |taxon| taxon == 'General' }.uniq.each do |taxon|
                # match using ILIKE to make match case-insensitive
                new_parent_candidate = parent_taxon.children.find_by('name ILIKE ? and taxonomy_id = ?', taxon, taxonomy.id)
                # save last matched taxon as parent
                break if new_parent_candidate.blank?
                parent_taxon = new_parent_candidate
              end

              parent_taxon if parent_taxon != taxonomy.root # disallow saving to taxonomy root
            end.compact.uniq

            # disallow saving to parents if matches contain childs
            matching_taxons = matching_taxons.reject do |taxon|
              matching_taxons.any? { |b| b != taxon && b.ancestors.find_by(id: taxon.id).present? }
            end

            if matching_taxons.any?
              matching_taxons.each do |taxon|
                taxon.products << product
              end
            else
              uncategorised_taxon = taxonomy.root.children.find_or_create_by!(name: 'Uncategorised', taxonomy: taxonomy, hidden: true)
              uncategorised_taxon.products << product
            end
          end
        end
      end
    end
  end
end

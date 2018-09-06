module Spree
  module Inventory
    module Providers
      class GenericClassifier < DefaultClassifier
        option :taxonomy_name

        attr_writer :taxon_candidates, :taxonomy

        def call
          case taxonomy_name
          when 'Books'
            Books::Classifier.call(product, taxon_candidates)
          else
            find_taxonomy_by_mapping
            super
          end
        end

        private

        def find_taxonomy_by_mapping
          if (taxons = find_taxons_in_mapping).blank?
            self.taxon_candidates = []
          else
            taxonomy_name = taxons.shift

            self.taxonomy = Taxonomy.find_or_create_by(name: taxonomy_name)
            self.taxon_candidates = taxons
          end
        end

        def find_taxons_in_mapping
          taxonomy_mapping.dig(taxonomy_name&.downcase)&.split(' / ')
        end

        def find_taxon(parent_taxon, taxon)
          parent_taxon.children
                      .find_or_create_by(name: taxon, taxonomy: taxonomy)
        end

        def taxonomy_mapping
          YAML.load_file(Rails.root.join('config', 'data', 'taxonomy_mapping.yml'))
              .transform_keys(&:downcase)
        end
      end
    end
  end
end

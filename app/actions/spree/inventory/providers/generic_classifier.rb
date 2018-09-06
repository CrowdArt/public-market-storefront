module Spree
  module Inventory
    module Providers
      class GenericClassifier < DefaultClassifier
        attr_writer :taxon_candidates, :taxonomy

        def call
          find_taxonomy_by_mapping
          super
        end

        private

        def find_taxonomy_by_mapping
          first_taxon = taxon_candidates.first

          return if (taxons = taxonomy_mapping.dig(first_taxon)&.split('; ')).blank?
          self.taxonomy = Taxonomy.find_by(name: taxons.shift) || taxonomy
          self.taxon_candidates = taxons
        end

        def taxonomy_mapping
          @taxonomy_mapping ||= YAML.load_file(Rails.root.join('config', 'data', 'taxonomy_mapping.yml'))
        end
      end
    end
  end
end

module Spree
  module Search
    module TaxonFilters
      module_function

      def applicable_filters(taxon)
        return [] if (variation_module = taxon.taxonomy.variation_module).blank?
        filters(variation_module)
      end

      def filters(variation_module)
        filters = []

        if (variation_options = variation_filter(variation_module)).present?
          filters << {
            name: 'Format',
            type: :variations,
            options: variation_options
          }
        end

        filters
      end

      def variation_filter(variation_module)
        variation_module::Properties.filterable_variations.map do |f|
          { label: f, value: f, id: f.parameterize }
        end
      end
    end
  end
end

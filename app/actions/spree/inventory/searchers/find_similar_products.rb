module Spree
  module Inventory
    module Searchers
      class FindSimilarProducts < BaseSearcher
        param :product
        option :filter_by_variation, optional: true

        def call
          find_similar
        end

        private

        def find_similar
          where_filters = fields_to_match
          where_filters.merge!(required_fields)
          where_filters.merge!(filters)

          Spree::Product.search(
            '*',
            where: where_filters,
            load: false
          )
        end

        def fields_to_match
          fields = {
            'name' => product.name,
            'in_stock' => { gt: 0 }
          }
          fields[product.author_property_name] = product.subtitle if product.subtitle
          fields
        end

        def required_fields
          return {} if product.taxonomy.blank?
          taxonomy_field = "#{product.taxonomy.name.downcase}_ids"
          { taxonomy_field => { not: nil }}
        end

        def filters
          filter_by_variation ? { variations: filter_by_variation } : {}
        end
      end
    end
  end
end

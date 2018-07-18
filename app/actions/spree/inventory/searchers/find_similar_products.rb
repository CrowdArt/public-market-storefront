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
          Spree::Product.search(
            body: {
              query: {
                bool: {
                  filter: filters,
                  should: should_fields
                }
              },
              timeout: '11s',
              size: 10_000, # defaults to 10 in ES
              explain: true
            },
            load: false
          )
        end

        def filters
          f = [
            { term: { 'name' => product.name }},
            { term: { product.author_property_name => product.subtitle }}
          ]

          f << { term: { variations: filter_by_variation }} if filter_by_variation

          f << { exists: { field: required_field }} if required_field.present?

          f
        end

        def should_fields # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          f = []

          variation_finder.similar_fields.each do |field|
            next if (property = product.property(field)).blank?
            f << { match: { field => property }}
          end

          variation_finder.date_fields.each do |field|
            next if (property = product.property(field)).blank?
            f << {
              range: {
                field => {
                  gte: property.to_date.beginning_of_year,
                  lte: property.to_date.end_of_year,
                  boost: 10 # date take precedence
                }
              }
            }
          end

          f
        end

        def required_field
          return {} if product.taxonomy.blank?
          "#{product.taxonomy.name.downcase}_ids"
        end

        def variation_finder
          product.taxonomy&.variation_module&.const_get('VariationFinder')
        end
      end
    end
  end
end

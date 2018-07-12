require 'dry-validation'

module Spree
  module Inventory
    module Providers
      module Books
        TAXONOMY = 'Books'.freeze

        class VariantProvider < DefaultVariantProvider
          PERMITTED_CONDITIONS = ['New', 'Like New', 'Excellent', 'Very Good', 'Good', 'Acceptable'].freeze
          ISBN_PROPERTY = 'isbn'.freeze
          VALIDATION_SCHEMA =
            ::Dry::Validation.Schema do
              required(:ean).filled(:str?)
              required(:sku).filled(:str?)
              required(:quantity).filled(:int?)
              required(:price).filled(:decimal?)
              required(:condition).value(included_in?: PERMITTED_CONDITIONS)
              optional(:notes).str?
              optional(:seller).str?
            end

          protected

          def metadata_provider
            BowkerMetadataProvider
          end

          def categorize(product, taxon_candidates)
            taxonomy = Spree::Taxonomy.create_with(filterable: true).find_or_create_by!(name: taxonomy_name)
            Books::Classifier.call(product, taxonomy, taxon_candidates)
          end

          def product_identifier(hash)
            hash[:ean]
          end

          def find_product(isbn)
            Product.joins(:properties)
                   .find_by(spree_properties: { name: ISBN_PROPERTY },
                            spree_product_properties: { value: isbn })
          end

          def product_option_types_attrs
            { option_type: condition_option_type }
          end

          def product_attrs(metadata)
            {
              name: metadata[:title],
              price: metadata[:price],
              description: metadata[:description],
              meta_description: metadata[:description],
              meta_title: metadata[:title],
              meta_keywords: metadata.dig(:properties, :subject),
              shipping_category: ShippingCategory.first_or_create(name: 'Default'),
              available_on: metadata[:available_on].presence || Time.current,
              discontinue_on: metadata[:discontinue_on].presence
            }
          end

          def condition_option_name
            'condition'
          end

          def master_variant_attributes(metadata)
            dims = metadata[:dimensions]
            {
              is_master: true,
              weight: dims[:weight],
              height: dims[:height],
              width: dims[:width],
              depth: dims[:depth]
            }
          end

          def condition_option_type
            option_type_attrs = {
              name: condition_option_name,
              presentation: 'Condition',
              option_values_attributes: PERMITTED_CONDITIONS.map { |c| { name: c, presentation: c } }
            }

            OptionType.where(name: option_type_attrs[:name]).first_or_create(option_type_attrs)
          end
        end
      end
    end
  end
end

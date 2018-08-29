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
              configure do
                option :permitted_conditions
              end

              required(:ean).filled(:str?)
              required(:sku).filled(:str?)
              required(:quantity).filled(:int?)
              required(:price).filled(:decimal?)
              required(:condition).value(included_in?: permitted_conditions)
              optional(:notes).str?
              optional(:seller).str?
            end

          protected

          def validation_options
            {
              permitted_conditions: self.class::PERMITTED_CONDITIONS
            }
          end

          def metadata_provider
            BowkerMetadataProvider
          end

          def classifier
            Books::Classifier
          end

          def product_identifier(hash)
            hash[:ean]
          end

          def find_product(isbn)
            Product.search(where: { isbn: isbn }).first
            # Product.joins(:properties)
            #        .find_by(spree_properties: { name: ISBN_PROPERTY },
            #                 spree_product_properties: { value: isbn })
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

          def variant_options(item)
            [{ name: condition_option_name, value: mapped_condition(item[:condition]) }]
          end

          def condition_option_name
            'condition'
          end

          def master_variant_attributes(metadata)
            attrs = { is_master: true }

            if (dims = metadata[:dimensions]).present?
              attrs.merge!(
                weight: dims[:weight],
                height: dims[:height],
                width: dims[:width],
                depth: dims[:depth]
              )
            end

            attrs
          end

          def condition_option_type
            option_type_attrs = {
              name: condition_option_name,
              presentation: 'Condition',
              option_values_attributes: PERMITTED_CONDITIONS.map do |c|
                mapped_condition = mapped_condition(c)
                { name: mapped_condition, presentation: mapped_condition }
              end
            }

            OptionType.where(name: option_type_attrs[:name]).first_or_create(option_type_attrs)
          end

          def mapped_condition(condition)
            I18n.t("products.mapped_conditions.#{condition}", default: condition)
          end
        end
      end
    end
  end
end

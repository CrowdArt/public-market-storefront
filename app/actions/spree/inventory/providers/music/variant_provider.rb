require 'dry-validation'

module Spree
  module Inventory
    module Providers
      module Music
        PERMITTED_MUSIC_FORMATS = ['vinyl'].freeze
        TAXONOMY = 'Music'.freeze

        class VariantProvider < DefaultVariantProvider
          PERMITTED_VINYL_CONDITIONS = ['SS', 'M-', 'VG+', 'VG', 'VG-', 'G+'].freeze

          VALIDATION_SCHEMA =
            ::Dry::Validation.Schema do
              required(:sku).filled(:str?)
              required(:quantity).filled(:int?)
              required(:price).filled(:decimal?)
              required(:format).filled.value(included_in?: PERMITTED_MUSIC_FORMATS)
              required(:artist).filled(:str?)
              required(:title).filled(:str?)
              required(:description).filled(:str?)
              required(:condition).value(included_in?: PERMITTED_VINYL_CONDITIONS)
              optional(:images)
              optional(:genres).str?
              optional(:notes).str?
              optional(:label).str?
              optional(:label_number).str?
              optional(:speed).str?
            end

          protected

          def process_item(hash)
            hash[:notes] = hash[:description]
            super(hash)
          end

          def find_metadata(_identifier)
            MetadataProvider.call(item_json.stringify_keys)
          end

          def product_identifier(hash)
            ['MSC', options[:vendor_id], hash[:sku]].join('-')
          end

          def find_product(_identifier)
            nil # products are always unique
          end

          def product_attrs(metadata)
            {
              name: metadata[:title],
              price: metadata[:price],
              description: metadata[:description],
              meta_description: metadata[:description],
              meta_title: metadata[:title],
              shipping_category: ShippingCategory.first_or_create(name: 'Default'),
              available_on: metadata[:available_on].presence || Time.current,
              discontinue_on: metadata[:discontinue_on].presence
            }
          end

          def master_variant_attributes(_metadata)
            {
              is_master: true
            }
          end

          def variant_option_value(item, _option_type)
            item[:condition]
          end

          def option_types
            permitted_conditions = PERMITTED_VINYL_CONDITIONS.map do |c|
              { name: c, presentation: t("option_values.vinyl_condition.#{c}") }
            end

            [{ name: 'vinyl_condition', presentation: 'Condition', values: permitted_conditions }]
          end
        end
      end
    end
  end
end

require 'dry-validation'

module Spree
  module Inventory
    module Providers
      class GenericVariantProvider < DefaultVariantProvider
        DEFAULT_OPTION_TYPE_NAME = 'Default'.freeze
        VALIDATION_SCHEMA =
          ::Dry::Validation.Schema do
            required(:sku).filled(:str?)
            required(:product_id).filled(:str?)
            required(:categories) { array? | str? }
            required(:quantity).filled(:int?)
            required(:price).filled(:decimal?)

            optional(:title) { str? }
            optional(:description) { str? }
            optional(:notes) { str? }
            optional(:option_types) { array? | str? }
            optional(:images) { array? | str? }
            optional(:weight) { float? | int? }
            optional(:height) { float? | int? }
            optional(:width) { float? | int? }
            optional(:depth) { float? | int? }
            optional(:rewards_percentage) { int? }
            optional(:keywords) { str? }
          end

        protected

        def find_metadata(_identifier)
          GenericMetadataProvider.call(item_json.stringify_keys, VALIDATION_SCHEMA.rules.keys, taxonomy_name: taxonomy_name)
        end

        def categorize(product, taxons)
          GenericClassifier.call(product, taxons.presence || original_taxons, taxonomy_name: taxonomy_name)
        end

        private

        def original_taxons
          @original_taxons ||= array(item_json[:categories]).map(&:humanize)
        end

        def taxonomy_name
          @taxonomy_name ||= original_taxons.first
        end

        def product_identifier(hash)
          hash[:product_id]
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

        def master_variant_attributes(metadata)
          dimemsions = metadata[:dimensions]
          {
            weight: dimemsions[:weight],
            height: dimemsions[:height],
            width: dimemsions[:width],
            depth: dimemsions[:depth]
          }
        end

        def variant_option_value(item, option_type)
          return DEFAULT_OPTION_TYPE_NAME if option_type[:name] == DEFAULT_OPTION_TYPE_NAME

          super(item, option_type)
        end

        def option_types
          types = item_json[:option_types].is_a?(Array) ? item_json[:option_types] : item_json[:option_types].to_s.split(',')

          return types.map(&:strip).map { |t| { name: t, presentation: t.humanize } } if types.present?

          [{ name: DEFAULT_OPTION_TYPE_NAME, presentation: 'Default', values: [{ name: DEFAULT_OPTION_TYPE_NAME }] }]
        end
      end
    end
  end
end

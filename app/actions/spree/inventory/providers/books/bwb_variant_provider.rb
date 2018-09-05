require 'dry-validation'

module Spree
  module Inventory
    module Providers
      module Books
        class BwbVariantProvider < VariantProvider
          PERMITTED_CONDITIONS = [
            'New',
            'Used - Like New',
            'Used - Excellent',
            'Used - Very Good',
            'Used - Good',
            'Used - Acceptable',
            'Collectible - Excellent',
            'Collectible - Like New',
            'Collectible - Very Good',
            'Collectible - Good',
            'Collectible - Acceptable'
          ].freeze

          VALIDATION_SCHEMA =
            ::Dry::Validation.Schema do
              configure do
                option :permitted_conditions
              end

              required(:isbn).filled(:str?)
              required(:bookid).filled(:str?)
              required(:quantity).filled?
              required(:price).filled?
              required(:condition).value(included_in?: permitted_conditions)
              optional(:author).str?
              optional(:title).str?
              optional(:publisher).str?
              optional(:description).str?
              optional(:status).str?
            end

          protected

          def process_item(hash)
            hash[:notes] = hash[:description]
            super(hash)
          end

          def mapped_condition(condition)
            condition
          end

          def find_metadata(identifier)
            # bowker meta take precedence
            bwb_meta.deep_merge(metadata_provider.call(identifier).compact)
          end

          def bwb_meta
            {
              title: item_json[:title],
              price: item_json[:price],
              properties: {
                isbn: item_json[:isbn],
                author: item_json[:author],
                publisher: item_json[:publisher]
              }
            }
          end

          def variant_sku(hash)
            hash[:bookid]
          end

          def product_identifier(hash)
            hash[:isbn]
          end
        end
      end
    end
  end
end

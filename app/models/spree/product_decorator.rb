module Spree
  module ProductDecorator
    MISSING_TITLE = '[Missing title]'.freeze

    def self.included(base) # rubocop:disable Metrics/AbcSize
      class << base
        prepend ClassMethods
      end
      base.prepend InstanceMethods

      base.include Spree::Core::NumberGenerator.new(prefix: 'PM', letters: true, length: 13)
      base.include PublicMarket::ProductKind

      base.before_validation :set_missing_title, if: -> { name.blank? }

      base.before_create :reset_boost_factor_if_no_images, if: -> { master.images.blank? }

      base.scope :in_stock, lambda {
        joins(variants: :stock_items).where('spree_stock_items.count_on_hand > ? OR spree_variants.track_inventory = ?', 0, false)
      }

      base.delegate :variation_module, to: :taxonomy, allow_nil: true
    end

    module InstanceMethods
      def should_generate_new_friendly_id?
        name_changed? || super
      end

      def update_best_price
        # get minimum price of best condition variant
        min_price = variants.in_stock
                            .joins(:prices)
                            .joins(%(
                              LEFT JOIN "spree_option_value_variants" ON "spree_option_value_variants"."variant_id" = "spree_variants"."id"
                              LEFT JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_value_variants"."option_value_id"
                              LEFT JOIN "spree_option_types" ON "spree_option_types"."id" = "spree_option_values"."option_type_id"
                                and "spree_option_types"."name" = 'condition'))
                            .reorder('spree_option_values.position asc, spree_prices.amount asc')
                            .limit(1)
                            .pluck('spree_prices.amount')
                            .first

        update(price: min_price) if min_price
      end

      # can be false
      def taxonomy
        @taxonomy ||= taxons.first&.taxonomy
      end

      # fields merged to searchkick's search_data
      def index_data
        {
          conversions_month: orders.complete.where('completed_at > ?', 1.month.ago).count,
          slug: slug,
          variations: search_variations
        }
      end

      def should_index?
        name != MISSING_TITLE && can_supply?
      end

      def search_variations
        variation_module_properties&.variation_properties(self) || []
      end

      def search_variation
        search_variations.first
      end

      def estimated_ptrn
        (price * 0.1).floor(2)
      end

      private

      def variation_module_properties
        variation_module&.const_get('Properties')
      end

      def reset_boost_factor_if_no_images
        self.boost_factor = 0
      end

      def set_missing_title
        self.name = MISSING_TITLE
      end
    end

    module ClassMethods
      # enable searchkick callbacks in RecalculateVendorVariantPrice
      # when price is included in searchkick index
      def search_fields
        %i[name author artist isbn]
      end
    end
  end
end

Spree::Product.include(Spree::ProductDecorator)

module Spree
  module ProductDecorator
    MISSING_TITLE = '[Missing title]'.freeze

    def self.included(base) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      class << base
        prepend ClassMethods
      end
      base.prepend InstanceMethods

      base.belongs_to :best_variant, class_name: 'Spree::Variant'

      base.class_variable_set :@@searchkick_options, base.searchkick_options.merge(
        word_start: base.autocomplete_fields
      )

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

      def update_best_variant
        # get minimum price of best condition variant
        best_variant = variants.in_stock
                               .joins(:prices)
                               .joins(%(
                                 LEFT JOIN "spree_option_value_variants" ON "spree_option_value_variants"."variant_id" = "spree_variants"."id"
                                 LEFT JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_value_variants"."option_value_id"
                                 LEFT JOIN "spree_option_types" ON "spree_option_types"."id" = "spree_option_values"."option_type_id"
                                   and "spree_option_types"."name" = 'condition'))
                               .reorder('spree_option_values.position asc, spree_prices.amount asc')
                               .limit(1)
                               .first

        update(price: best_variant.price, best_variant: best_variant) if best_variant
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
          variations: variations,
          filter_variations: filterable_variations
        }
      end

      def should_index?
        # use variants query instead of can_supply?
        name != MISSING_TITLE && variants.active.in_stock.any?
      end

      # variations visible on product page/product card
      def variations
        variation_module_properties&.variation_properties(self) || []
      end

      def variation
        variations.first
      end

      # variations availabe in search filters
      def filterable_variations
        variation_module_properties&.filter_properties(self) || []
      end

      def rewards
        best_variant&.final_rewards || Spree::Config.rewards
      end

      def rewards_amount
        (price * rewards / 100.0).floor(3)
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
        autocomplete_fields + %i[isbn]
      end

      def autocomplete_fields
        %i[name author artist]
      end
    end
  end
end

Spree::Product.include(Spree::ProductDecorator)

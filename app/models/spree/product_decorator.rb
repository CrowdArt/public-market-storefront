module Spree
  module ProductDecorator
    MISSING_TITLE = '[Missing title]'.freeze

    def self.included(base) # rubocop:disable Metrics/AbcSize
      singleton_class.prepend ClassMethods
      base.prepend InstanceMethods

      base.include Spree::Core::NumberGenerator.new(prefix: 'PM', letters: true, length: 13)

      base.before_validation :set_missing_title, if: -> { name.blank? }
      base.before_create :reset_boost_factor_if_no_images, if: -> { master.images.blank? }

      base.scope :in_stock, lambda {
        joins(variants: :stock_items).where('spree_stock_items.count_on_hand > ? OR spree_variants.track_inventory = ?', 0, false)
      }
    end

    module InstanceMethods
      def author
        product_properties.joins(:property)
                          .where("spree_properties.name = 'author' OR spree_properties.name = 'manufacturer'")
                          .select('spree_product_properties.property_id, spree_product_properties.value, spree_properties.name as property_name')
                          .first
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
        taxons.first&.taxonomy
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
        return if taxonomy&.variation_module.blank?
        taxonomy.variation_module::Properties.variation_properties(self)
      end

      def estimated_ptrn
        (price * 0.1).floor
      end

      def variations
        Spree::Inventory::FindProductVariations.call(self)
      end

      private

      def reset_boost_factor_if_no_images
        self.boost_factor = 0
      end

      def set_missing_title
        self.name = MISSING_TITLE
      end
    end

    module ClassMethods
      def search_where
        {
          active: true,
          price: { not: nil },
          boost_factor: { gt: 1 }
        }
      end

      def autocomplete_fields
        %i[name author]
      end

      # enable searchkick callbacks in RecalculateVendorVariantPrice
      # when price is included in searchkick index
      def search_fields
        %i[name author isbn]
      end

      def autocomplete(keywords) # rubocop:disable Metrics/MethodLength
        if keywords
          Spree::Product.search(
            keywords,
            includes: [master: :prices],
            fields: autocomplete_fields,
            match: :word_start,
            limit: 10,
            misspellings: { below: 3 },
            where: search_where
          ).uniq
        else
          Spree::Product.search(
            '*',
            includes: [master: :prices],
            fields: autocomplete_fields,
            misspellings: { below: 3 },
            where: search_where
          )
        end
      end
    end
  end
end

Spree::Product.include(Spree::ProductDecorator)

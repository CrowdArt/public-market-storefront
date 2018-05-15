Spree::Product.class_eval do
  include Spree::Core::NumberGenerator.new(prefix: 'PM', letters: true, length: 13)

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

  def self.autocomplete_fields
    %i[name author]
  end

  # enable searchkick callbacks in RecalculateVendorVariantPrice
  # when price is included in searchkick index
  def self.search_fields
    %i[name author isbn]
  end

  def index_data
    { slug: slug }
  end

  def should_index?
    can_supply?
  end

  def estimated_ptrn
    (price * 0.1).floor
  end

  def self.autocomplete(keywords) # rubocop:disable Metrics/MethodLength
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

  # TODO: filter articles boosted by admins
  def self.staff_picks # rubocop:disable Metrics/MethodLength
    Spree::Product.search(
      '*',
      includes: [master: :prices],
      limit: 3,
      where: search_where
    )
  end
end

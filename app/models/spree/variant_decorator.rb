Spree::Variant.class_eval do
  # assume that first option value is main
  def main_option_value
    option_values&.first&.presentation || 'Default'
  end

  def main_option_type
    option_values&.first&.option_type
  end

  def self.find_best_price_in_best_main_option
    in_stock
      .not_discontinued
      .not_deleted
      .includes(:vendor, option_values: :option_value_variants)
      .joins(:option_values, :product, :default_price)
      .reorder('spree_variants.product_id, spree_option_values.position ASC, spree_prices.amount ASC')
      .select('DISTINCT ON (spree_variants.product_id) spree_variants.*')
  end
end

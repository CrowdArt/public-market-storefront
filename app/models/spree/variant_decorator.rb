Spree::Variant.class_eval do
  def main_option_value
    main_option&.presentation || 'Default'
  end

  def mapped_main_option_value
    conditions = I18n.t("variations.options.#{product.taxonomy&.name&.downcase}").stringify_keys
    conditions.find { |_k, v| v.include?(main_option_name.downcase) }&.first || main_option_name
  end

  def main_option_name
    main_option&.name
  end

  def main_option_type
    option_values&.first&.option_type
  end

  def self.find_best_price_in_option
    in_stock
      .not_discontinued
      .not_deleted
      .includes(:vendor, :option_value_variants)
      .joins(:option_values, :product, :default_price)
      .reorder('spree_variants.product_id, spree_option_values.position ASC, spree_prices.amount ASC')
      .select('DISTINCT ON (spree_variants.product_id) spree_variants.*')
  end

  private

  # assume that first option value is main
  def main_option
    option_values&.first
  end
end

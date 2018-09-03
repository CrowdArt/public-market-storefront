Spree::Variant.class_eval do
  def main_option_value
    main_option&.presentation || 'Default'
  end

  def mapped_main_option_value
    conditions = I18n.t("variations.options.#{main_option_type&.name&.downcase}", default: {}).stringify_keys
    conditions.find { |_k, v| v.include?(main_option_name&.downcase) }&.first || main_option_name
  end

  def main_option_name
    main_option&.name
  end

  def main_option_type
    main_option&.option_type
  end

  def final_rewards
    rewards || vendor&.rewards || Spree::Config.rewards
  end

  def rewards_amount
    PublicMarket::RewardsCalculator.call(price, final_rewards)
  end

  # assume that first option value is main
  def main_option
    return @main_option if defined?(@main_option)
    @main_option = option_values&.first
  end

  def self.find_best_price_in_option(in_stock: true)
    q =
      not_discontinued.not_deleted
                      .joins(:option_values, :prices)
                      .reorder('spree_variants.product_id, spree_option_values.position ASC, spree_prices.amount ASC')
                      .select('DISTINCT ON (spree_variants.product_id) spree_variants.*')
    q = q.in_stock if in_stock
    q
  end
end

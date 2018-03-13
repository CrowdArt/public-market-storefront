Spree::ProductsController.class_eval do
  # rubocop:disable Metrics/AbcSize
  def show
    @variants = @product.variants_including_master
                        .spree_base_scopes
                        .in_stock
                        .active(current_currency)
                        .includes(:option_values)
                        .reorder('spree_option_values.position ASC, spree_prices.amount ASC')
                        .select('spree_prices.amount')
                        .group_by { |v| v.option_values.first.presentation } # assume that first option value is main
                        .map(&method(:prepare_buy_box_variants))

    @product_properties = @product.product_properties.includes(:property)
    @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
    redirect_if_legacy_path
  end
  # rubocop:enable Metrics/AbcSize

  private

  def prepare_buy_box_variants(option_variants)
    option_value = option_variants[0]
    variants = option_variants[1]

    median_price = Spree::Price.new(amount: variants.map(&:price).median, currency: current_currency)

    {
      option_value: option_value,
      variant: variants.first,
      median_price: median_price.money
    }
  end
end

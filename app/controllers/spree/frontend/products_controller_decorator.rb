Spree::ProductsController.class_eval do
  # rubocop:disable Metrics/AbcSize
  def show
    @variants = @product.variants_including_master
                        .spree_base_scopes
                        .in_stock
                        .active(current_currency)
                        .includes(:option_values, :images, :prices)
                        .reorder('spree_option_values.position ASC')
    @product_properties = @product.product_properties.includes(:property)
    @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
    redirect_if_legacy_path
  end
  # rubocop:enable Metrics/AbcSize
end

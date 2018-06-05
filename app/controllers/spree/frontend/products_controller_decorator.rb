Spree::ProductsController.class_eval do
  before_action :save_return_to, :load_taxon, only: :show

  def show # rubocop:disable Metrics/AbcSize
    @product_properties = @product.product_properties.includes(:property)

    redirect_if_legacy_path
  end

  def autocomplete
    keywords = params[:keywords] ||= nil
    @products = Spree::Product.autocomplete(keywords)
    respond_to do |format|
      format.json
    end
  end

  private

  def load_taxon
    taxon_id = params[:taxon_id]
    @taxon = taxon_id.present? ? Spree::Taxon.find(taxon_id) : @product.taxons.first
  end
end

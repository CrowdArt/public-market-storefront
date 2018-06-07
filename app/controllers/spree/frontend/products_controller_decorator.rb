Spree::ProductsController.class_eval do
  before_action :save_return_to, :load_taxon, only: :show

  def best_selling
    # params.merge(taxon: @taxon.id) if @taxon
    @products = build_searcher(params.merge(sort: { popularity: :all_time })).call
    render action: :index
  end

  def index
    searcher_opts = {}

    # NOTE: products should be searchable by root taxon
    # if params[:taxon].present? && (@taxon = Spree::Taxon.find(params[:taxon]))
    #   searcher_opts[:taxon_ids] = [@taxon.id]
    # end

    @products = build_searcher(params, searcher_opts).call
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def show
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

module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :save_return_to, :load_taxon, only: :show
    end

    def best_selling
      params[:sort] ||= { popularity: 'all_time' }
      @products = build_searcher(params).call

      respond_to do |format|
        format.html { render action: :index }
        format.js { render 'spree/shared/search/products' }
      end
    end

    def index
      searcher_opts = {}

      if params[:taxon].present?
        @taxon = Spree::Taxon.find(params[:taxon])
        searcher_opts[:taxon_ids] = [@taxon.id] if @taxon
      end

      @products = build_searcher(params, searcher_opts).call

      respond_to do |format|
        format.html
        format.js { render 'spree/shared/search/products' }
      end
    end

    def show
      @product_properties = @product.product_properties.includes(:property)

      redirect_if_legacy_path
    end

    def autocomplete
      @products = Spree::Inventory::Searchers::Autocomplete.new(limit: 10, keywords: params[:keywords]).call.results
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
end

Spree::ProductsController.prepend(Spree::ProductsControllerDecorator)

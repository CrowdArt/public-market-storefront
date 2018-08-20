module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :save_return_to, only: :show
      base.before_action :load_product, only: %i[show similar_variants]
      base.before_action :load_taxon_from_taxon_id, only: %i[show autocomplete]
      base.include FrontendHelper
      base.include SimilarVariantsHelper
    end

    def index # rubocop:disable Metrics/AbcSize
      searcher_opts = {}

      if (@taxon = Spree::Taxon.find_by(id: params[:taxon])).present?
        searcher_opts[:taxon_ids] = [@taxon.id]
        @card_size = :medium
      end

      @products = build_searcher(params, opts: searcher_opts).call

      show_taxons = @taxon && mobile? && @taxon.root? && params[:keywords].blank?

      respond_to do |format|
        format.html { render show_taxons ? 'spree/taxons/show' : 'spree/products/index' }
        format.js { render 'spree/shared/search/products' }
      end
    end

    def show
      @previous_variation = Spree::Product.find_by(slug: params[:variation])
      redirect_if_legacy_path
    end

    def best_selling
      params[:sort] ||= { popularity: 'all_time' }

      searcher_opts = {}
      searcher_opts[:taxon_ids] = [@taxon.id] if @taxon.present?

      @products = build_searcher(params, opts: searcher_opts).call

      respond_to do |format|
        format.html { render action: :index }
        format.js { render 'spree/shared/search/products' }
      end
    end

    def autocomplete
      opts = {
        limit: 10,
        keywords: params[:keywords]
      }
      opts[:taxon_ids] = @taxon.id if @taxon

      @products = Spree::Inventory::Searchers::Autocomplete.call(opts).results

      respond_to do |format|
        format.json
      end
    end

    def similar_variants
      @variation = params[:variation]
      return redirect_to @product unless @product.variations.include?(@variation)
      @variants = Spree::Inventory::FindProductVariations.call(@product, filter_by_variation: @variation, load_variants: true)
                                                         .first&.dig(:similar_variants)
    end

    private

    def load_taxon_from_taxon_id
      taxon_id = params[:taxon_id]
      @taxon =
        if taxon_id.present?
          Spree::Taxon.find_by(id: taxon_id)
        elsif @product
          @product.taxons.first
        end
    end
  end

  ProductsController.prepend(ProductsControllerDecorator)
end

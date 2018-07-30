module Spree
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :save_return_to, only: :show
      base.before_action :load_product, only: %i[show similar_variants]
      base.before_action :load_taxon, only: %i[show autocomplete]
      base.include SimilarVariantsHelper
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

      if (@taxon = Spree::Taxon.find_by(id: params[:taxon])).present?
        searcher_opts[:taxon_ids] = [@taxon.id]
        @card_size = :medium
      end

      @products = build_searcher(params, searcher_opts).call

      respond_to do |format|
        format.html { render @taxon ? 'spree/taxons/show' : 'spree/products/index' }
        format.js { render 'spree/shared/search/products' }
      end
    end

    def show
      @previous_variation = Spree::Product.find_by(slug: params[:variation])
      redirect_if_legacy_path
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

    def load_taxon
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

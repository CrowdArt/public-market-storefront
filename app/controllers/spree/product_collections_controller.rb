module Spree
  class ProductCollectionsController < Spree::StoreController
    include Spree::ProductsHelper
    helper_method :cache_key_for_product # not inclusion causes exception in product partial

    before_action :load_product_collection, only: [:show]

    after_action :add_vary_header, only: :show

    def show # rubocop:disable Metrics/AbcSize
      params[:filter] ||= {}
      params[:filter][:collections] = [@collection.id]

      @hide_taxon_breadcrumbs = true
      @taxon = @collection.taxonomy&.root
      @products = build_searcher(params).call

      respond_to do |format|
        format.html { render 'spree/products/index' }
        format.js { render 'spree/shared/search/products' }
      end
    end

    private

    def load_product_collection
      @collection = ProductCollection.friendly.find(params[:id])
    end
  end
end

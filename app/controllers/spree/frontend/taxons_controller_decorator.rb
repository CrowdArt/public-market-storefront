module Spree
  module TaxonsControllerDecorator
    def self.prepended(base)
      base.include FrontendHelper
      base.include SearchFiltersHelper
      base.skip_before_action :set_current_order, only: :mobile_menu_childs
    end

    def show # rubocop:disable Metrics/AbcSize
      @taxon = Spree::Taxon.friendly.find(params[:id])
      return unless @taxon

      @card_size = :medium

      return if mobile? && !@taxon.depth.positive?
      @products = build_searcher(params, opts: { taxon_ids: [@taxon.id] }).call

      respond_to do |format|
        format.html
        format.js { render 'spree/shared/search/products' }
      end
    end

    # fetch taxons in mobile nav menu
    def mobile_menu_childs
      root_taxons = Spree::Taxon.roots.visible.reorder(:name)
      render collection: root_taxons, partial: 'spree/nav/mobile_menu_subcategories', as: :taxon
    end
  end
end

Spree::TaxonsController.prepend(Spree::TaxonsControllerDecorator)

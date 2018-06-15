module Spree
  module TaxonsControllerDecorator
    def self.prepended(base)
      base.include SearchFiltersHelper
      base.skip_before_action :set_current_order, only: :mobile_menu_childs
    end

    def show
      @taxon = Spree::Taxon.friendly.find(params[:id])
      return unless @taxon

      return if browser.device.mobile? && !@taxon.depth.positive?
      @products = build_searcher(params, taxon_ids: [@taxon.id]).call
    end

    # fetch taxons in mobile nav menu
    def mobile_menu_childs
      root_taxons = Spree::Taxon.roots.visible.reorder(:name)
      render collection: root_taxons, partial: 'spree/nav/mobile_menu_subcategories', as: :taxon
    end
  end
end

Spree::TaxonsController.prepend(Spree::TaxonsControllerDecorator)

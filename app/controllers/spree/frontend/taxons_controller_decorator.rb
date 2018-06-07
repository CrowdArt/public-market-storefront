Spree::TaxonsController.class_eval do
  skip_before_action :set_current_order, only: :mobile_menu_childs

  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon

    @products = build_searcher(params, taxon_ids: [@taxon.id]).call

    @taxonomies = Spree::Taxonomy.where(id: @taxon.taxonomy_id)
                                 .includes(root: { children: :products })
  end

  # fetch taxons in mobile nav menu
  def mobile_menu_childs
    root_taxons = Spree::Taxon.roots.visible.reorder(:name)
    render collection: root_taxons, partial: 'spree/nav/mobile_menu_subcategories', as: :taxon
  end
end

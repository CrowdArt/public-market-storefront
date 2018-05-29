Spree::TaxonsController.class_eval do
  skip_before_action :set_current_order, only: :mobile_menu_childs

  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon

    @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
    @products = @searcher.retrieve_products

    @taxonomies = Spree::Taxonomy.where(id: @taxon.taxonomy_id)
                                 .includes(root: { children: :products })
  end

  # fetch taxons in mobile nav menu
  def mobile_menu_childs
    root_taxons = Spree::Taxon.roots.where(hidden: false).reorder(position: :asc)
    render collection: root_taxons, partial: 'spree/nav/mobile_menu_subcategories', as: :taxon
  end
end

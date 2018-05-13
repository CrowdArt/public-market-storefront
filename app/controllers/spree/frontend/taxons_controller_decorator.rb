Spree::TaxonsController.class_eval do
  skip_before_action :set_current_order, only: :mobile_menu_childs

  def mobile_menu_childs
    root_taxons = Spree::Taxon.roots.where(hidden: false).reorder(position: :asc)
    render collection: root_taxons, partial: 'spree/nav/mobile_menu_subcategories', as: :taxon
  end
end

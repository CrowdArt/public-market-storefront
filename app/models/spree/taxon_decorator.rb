Spree::Taxon.class_eval do
  MIN_PRODUCTS = 20
  # scope :childrens_with_min_products, -> { joins(:products).group('spree_taxons.id').having("count(taxon_id) > 1") }
  def childrens_with_min_products
    children.joins(:products).group('spree_taxons.id').having('count(taxon_id) > 1')
  end
end

Spree::HomeController.class_eval do
  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
    @staff_picks = Spree::Product.staff_picks(10).to_a.sample(3)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end

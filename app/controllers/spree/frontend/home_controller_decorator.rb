Spree::HomeController.class_eval do
  def index # rubocop:disable Metrics/AbcSize
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
    @staff_picks = Spree::Product.staff_picks
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end

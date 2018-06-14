Spree::HomeController.class_eval do
  def index
    @products = build_searcher(params).call
    @staff_picks = Spree::Inventory::Searchers::StaffPicks.new(limit: 10).call.to_a.sample(3)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end

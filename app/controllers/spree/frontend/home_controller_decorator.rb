module Spree
  module HomeControllerDecorator
    def self.prepended(base)
      base.include Spree::HomepageHelper
    end

    def index
      @products = build_searcher(params).call
      @taxonomies = Taxonomy.includes(root: :children)

      return if (staff_picks_collection = ProductCollection.staff_picks).blank?
      @staff_picks = Inventory::Searchers::ProductSearcher.call(limit: 3, filter: { collections: [staff_picks_collection.id] })
    end
  end

  HomeController.prepend(HomeControllerDecorator)
end

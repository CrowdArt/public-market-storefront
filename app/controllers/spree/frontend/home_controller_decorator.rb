module Spree
  module HomeControllerDecorator
    def self.prepended(base)
      base.before_action :load_product_collections, only: :index
    end

    def index
      @products = build_searcher(params).call
      @taxonomies = Taxonomy.includes(root: :children)

      return if (staff_picks_collection = ProductCollection.staff_picks).blank?
      @staff_picks = Inventory::Searchers::ProductSearcher.call(limit: 3, filter: { collections: [staff_picks_collection.id] })
    end

    private

    def load_product_collections
      @product_collections =
        ProductCollection.where.not(name: ProductCollection::STAFF_PICKS_NAME)
                         .joins(:products)
                         .promoted
                         .order('RANDOM()')
                         .uniq
                         .take(4)
    end
  end

  HomeController.prepend(HomeControllerDecorator)
end

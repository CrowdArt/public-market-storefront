module Spree
  module HomepageHelper
    def home_top_collections_cache_key
      [:v3, :home, :top_collections, (ProductCollection.maximum(:updated_at) || Time.zone.today).to_s(:number)]
    end

    def fetch_staff_picks
      return if (staff_picks_collection = ProductCollection.staff_picks).blank?
      staff_picks_opts = {
        limit: 3,
        sort: { popularity: 'all_time' },
        filter: { collections: [staff_picks_collection.id] }
      }

      Inventory::Searchers::ProductSearcher.call(staff_picks_opts)
    end

    def fetch_product_collections
      ProductCollection.where.not(name: ProductCollection::STAFF_PICKS_NAME)
                       .joins(:products)
                       .promoted
                       .order(Arel.sql('random()'))
                       .uniq
                       .take(4)
    end
  end
end

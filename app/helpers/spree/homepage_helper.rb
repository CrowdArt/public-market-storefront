module Spree
  module HomepageHelper
    def home_top_categories_cache_key
      top_categories = home_top_categories.map { |c| c[:name] }
      [:v3, :home, :top_categories, (Spree::Taxon.where(name: top_categories).maximum(:updated_at) || Time.zone.today).to_s(:number)]
    end

    def home_top_categories
      @home_top_categories ||=
        [
          { name: 'Music', url: top_selling_taxon_path('music', filter: { variations: %w[vinyl] }) },
          { name: 'Books', url: top_selling_taxon_path('books') }
        ]
    end
  end
end

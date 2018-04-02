module PublicMarket
  MAX_PAGES = 1000

  module ResultsMaxPages
    def total_pages
      [MAX_PAGES, super].min
    end
  end

  module SearchMaxPages
    def build_searcher(params)
      params[:page] = [MAX_PAGES, params[:page].to_i].min
      super(params)
    end
  end
end

Searchkick::Results.prepend(PublicMarket::ResultsMaxPages)
Spree::Core::ControllerHelpers::Search.prepend(PublicMarket::SearchMaxPages)

module PublicMarket
  MAX_PAGES = 500

  module ResultsMaxPages
    def total_pages
      [MAX_PAGES, super].min
    end
  end
end

Searchkick::Results.prepend(PublicMarket::ResultsMaxPages)

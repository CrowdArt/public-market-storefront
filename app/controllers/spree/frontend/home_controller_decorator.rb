module Spree
  module HomeControllerDecorator
    def index
      @products = build_searcher(params).call
    end
  end

  HomeController.prepend(HomeControllerDecorator)
end

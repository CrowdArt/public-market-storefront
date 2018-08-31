module Spree
  module HomeControllerDecorator
    def index
      @products = build_searcher(params).call
    end

    def sell
      @merchant = PublicMarket::Merchant.new
    end

    def sell_apply_confirm
      flash[:success] = t('sell.success')
      redirect_to root_path
    end
  end

  HomeController.prepend(HomeControllerDecorator)
end

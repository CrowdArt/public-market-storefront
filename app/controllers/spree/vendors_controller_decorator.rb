Spree::VendorsController.class_eval do
  def show
    @products = @vendor.products
                       .includes(:tax_category, { master: %i[prices default_price] }, { best_variant: :vendor })
                       .page(params[:page])
                       .per(Spree::Config[:products_per_page])
  end
end

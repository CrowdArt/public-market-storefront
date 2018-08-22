Spree::Api::V1::InventoryController.class_eval do
  def fetch
    authorize! :index, Spree::Variant

    @items = Spree::Variant.where(vendor: current_spree_vendor)
                           .page(params[:page])
                           .per(params[:per_page])
  end

  private

  def current_spree_vendor
    @current_spree_vendor ||= current_api_user.vendors.first
  end
end

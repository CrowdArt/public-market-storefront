Spree::Admin::OrdersController.class_eval do
  include BeforeRender
  before_render :show_vendor_info, only: %i[index]
  before_action :load_vendor_view, only: %i[edit cart show]

  private

  def load_vendor_view
    @order = vendor_view(@order) if current_spree_vendor
  end

  def show_vendor_info
    return unless current_spree_vendor

    @orders.each do |order|
      view = vendor_view(order)
      order.total = view.total
    end
  end

  def vendor_view(order)
    Spree::Orders::VendorView.new(order, current_spree_vendor)
  end
end

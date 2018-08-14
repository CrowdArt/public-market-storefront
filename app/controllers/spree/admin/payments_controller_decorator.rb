Spree::Admin::PaymentsController.class_eval do
  before_action :load_vendor_view, only: %i[index]

  private

  def load_vendor_view
    @order = Spree::Orders::VendorView.new(@order, current_spree_vendor) if current_spree_vendor
  end
end

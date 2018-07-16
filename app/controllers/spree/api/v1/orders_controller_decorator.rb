Spree::Api::V1::OrdersController.class_eval do
  before_action :find_order, except: %i[create mine current index update remove_coupon_code fetch update_items]

  def fetch
    authorize! :index, Spree::Order

    @from = Time.zone.at(fetch_params[:from_timestamp].to_i)
    @orders = current_spree_vendor.blank? ? [] : Spree::Orders::FetchVendorOrdersAction.call(current_spree_vendor, @from)

    respond_with(@orders)
  end

  def update_items
    authorize! :create, Spree::Shipment

    @result = {}

    update_params.each do |order|
      options = order_update_params(order).merge(user: current_api_user)
      item = Spree::Orders::UpdateLineItemAction.new(options).call
      @result.merge!(item)
    end
  end

  private

  def current_spree_vendor
    @current_spree_vendor ||= current_api_user.vendors.first
  end

  def fetch_params
    params.permit(:from_timestamp)
  end

  def order_update_params(order)
    order.permit([permitted_order_attributes]).to_h
  end

  def update_params
    params.require(:updates)
  end

  def permitted_order_attributes
    %i[order_number item_number action tracking_number shipped_at]
  end
end

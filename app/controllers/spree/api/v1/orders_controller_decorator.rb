Spree::Api::V1::OrdersController.class_eval do
  before_action :find_order, except: %i[create mine current index update remove_coupon_code fetch update_shipments]

  def fetch
    authorize! :index, Spree::Order

    @from = Time.zone.at(fetch_params[:from_timestamp].to_i)
    @orders = current_spree_vendor.blank? ? [] : Spree::Orders::FetchVendorOrdersAction.call(current_spree_vendor, @from)

    respond_with(@orders)
  end

  def update_shipments
    authorize! :create, Spree::Shipment

    @success = 0
    @failures = {}

    orders_params.each_with_index do |order, index|
      options = order_update_params(order).merge(user: current_api_user)
      Spree::Orders::UpdateLineItemAction.new(options).call
      @success += 1
    rescue StandardError => e
      @failures[index] = e.message.gsub('Spree::', '')
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

  def orders_params
    params.require(:orders)
  end

  def permitted_order_attributes
    %i[number action]
  end
end

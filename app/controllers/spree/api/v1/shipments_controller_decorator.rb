Spree::Api::V1::ShipmentsController.class_eval do
  before_action :find_shipment_and_units, only: %i[cancel_item confirm_item]

  def cancel_item
    item_action(:cancel, :can_cancel?)
  end

  def confirm_item
    item_action(:ship, :can_ship?)
  end

  private

  def item_action(method, can)
    units = @inventory_units.select(&can)
    if units.count >= @quantity
      units.last(@quantity).each(&method)
      render json: { success: true }
    else
      render_error(Spree.t(:no_enough_units, action: method, quantity: @quantity))
    end
  end

  def render_error(message)
    render json: { success: false, message: message }, status: :unprocessable_entity
  end

  def find_shipment_and_units
    @shipment = Spree::Shipment.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
    @inventory_units = @shipment.inventory_units.where(variant_id: params[:variant_id])
    @quantity = params[:quantity].to_i
  end
end

Spree::CheckoutController.class_eval do
  # storefront changes:
  # - payment_sources changed to credit_cards
  # - allow rendering js in checkout flow

  before_action :set_addresses, only: :update

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # Updates the order and advances to the next state (when possible.)
  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        Tracker.track(mixpanel_user_id, "order completed", {
          order_id: @order.id
        })
        redirect_to completion_route
      else
        Tracker.track(mixpanel_user_id, "order change state", {
          order_id: @order.id,
          state: @order.state
        })
        redirect_to checkout_state_path(@order.state)
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js do
          flash[:error] = @order.errors.full_messages.join("\n")
          render :update
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  protected

  def set_addresses
    return unless params[:order] && params[:state] == 'address'

    # if user uses existing user's shipping address - copy it to order
    # if user creates new address - save it to user's account
    # if address exists in order - update instead of create new one
    if params[:order][:ship_address_id]
      address = Spree::Address.find(params[:order][:ship_address_id])
      params[:order][:ship_address_attributes].merge!(address.attributes.except('id', 'user_id', 'updated_at', 'created_at'))
    else
      params[:save_user_address] = '1'
    end

    params[:order].delete(:ship_address_id)
  end

  private

  def before_address
    @addresses = spree_current_user&.addresses
    @new_address =
      if @addresses.present? || @order.ship_address.blank?
        Spree::Address.build_default
      else
        @order.ship_address
      end
  end

  def before_payment
    if @order.checkout_steps.include?('delivery')
      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    @payment_sources = try_spree_current_user.credit_cards if try_spree_current_user&.respond_to?(:credit_cards)
    @credit_card = Spree::CreditCard.new
    @credit_card.address = Spree::Address.build_default
  end
  # rubocop:enable Metrics/AbcSize

  def permitted_checkout_attributes
    permitted_attributes.checkout_attributes + [
      :ship_address_id,
      bill_address_attributes: permitted_address_attributes,
      ship_address_attributes: permitted_address_attributes + [:user_id],
      payments_attributes: permitted_payment_attributes,
      shipments_attributes: permitted_shipment_attributes
    ]
  end

  def permitted_payment_attributes
    permitted_attributes.payment_attributes + [
      source_attributes: permitted_source_attributes
    ]
  end
end

Spree::CheckoutController.class_eval do
  # storefront changes:
  # - payment_sources changed to credit_cards
  # - allow rendering js in checkout flow

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
        redirect_to completion_route
      else
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

  private

  def before_address
    @order.ship_address ||= (spree_current_user&.ship_address&.clone || Spree::Address.build_default)
  end

  def before_payment
    if @order.checkout_steps.include? 'delivery'
      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    @payment_sources = try_spree_current_user.credit_cards if try_spree_current_user&.respond_to?(:credit_cards)
    @credit_card = Spree::CreditCard.new
    @credit_card.address ||= spree_current_user.shipping_address || Spree::Address.build_default
  end
  # rubocop:enable Metrics/AbcSize

  def permitted_checkout_attributes
    permitted_attributes.checkout_attributes + [
      bill_address_attributes: permitted_address_attributes,
      ship_address_attributes: permitted_address_attributes,
      payments_attributes: permitted_payment_attributes,
      shipments_attributes: permitted_shipment_attributes
    ]
  end

  def permitted_payment_attributes
    permitted_attributes.payment_attributes + [
      source_attributes: permitted_source_attributes + [:use_shipping, address_attributes: permitted_address_attributes]
    ]
  end
end

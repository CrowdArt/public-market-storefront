Spree::CheckoutController.class_eval do
  # storefront changes:
  # - payment_sources changed to credit_cards
  # - allow rendering js in checkout flow

  before_action :set_addresses, only: :update

  before_action :before_address, :before_delivery, :before_payment, only: [:edit]

  def registration
    render 'spree/user_registrations/new', locals: { resource: Spree::User.new }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # Updates the order and advances to the next state (when possible.)
  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]

      @order.transition_to_complete!

      if @order.completed?
        @current_order = nil
        flash[:order_completed] = true
        Tracker.track(mixpanel_user_id, 'order completed', order_id: @order.id)

        respond_to do |format|
          format.html { redirect_to completion_route }
          format.js do
            render js: "window.location.href='#{completion_route}'"
          end
        end
      end
    end

    if (errors = @order.errors).any?
      flash[:error] = errors.full_messages.join("\n")

      respond_to do |format|
        format.html { render :edit }
        format.js do
          render :update, status: :unprocessable_entity
        end
      end
    end
  rescue Spree::Core::GatewayError => e
    before_payment
    flash[:error] = e.message
    respond_to do |format|
      format.html { render :edit }
      format.js { render :update, status: :unprocessable_entity }
    end
  end
  # rubocop:enable Metrics/MethodLength

  protected

  def set_addresses
    return if params[:order].blank?

    # if user uses existing user's shipping address - copy it to order
    # if user creates new address - save it to user's account
    # if address exists in order - update instead of create new one
    if params[:order][:ship_address_id]
      address = Spree::Address.find(params[:order][:ship_address_id])
      params[:order][:ship_address_attributes].merge!(address.attributes.except('id', 'user_id', 'updated_at', 'created_at'))
    else
      params[:save_user_address] = '1'
    end

    use_billing_address if params[:order_use_billing_address] == 'yes'

    params[:order].delete(:ship_address_id)
  end

  private

  def check_registration
    return if spree_current_user
    store_location
    redirect_to spree.checkout_registration_path
  end

  def skip_state_validation?
    false
  end

  def before_address
    return unless spree_user_signed_in?

    @addresses = spree_current_user.addresses.order(default: :desc, id: :desc)
    @new_address =
      if @addresses.present? || @order.ship_address.blank?
        Spree::Address.build_default
      else
        @order.ship_address
      end
  end

  def before_payment
    # if @order.checkout_steps.include?('delivery')
    #   packages = @order.shipments.map(&:to_package)
    #   @differentiator = Spree::Stock::Differentiator.new(@order, packages)
    #   @differentiator.missing.each do |variant, quantity|
    #     @order.contents.remove(variant, quantity)
    #   end
    # end

    @payment_sources = try_spree_current_user.credit_cards.order(default: :desc, id: :desc) if try_spree_current_user&.respond_to?(:credit_cards)
    stripe_payment_method = Spree::PaymentMethod.available.find_by(type: 'Spree::Gateway::StripeGateway')
    @credit_card = Spree::CreditCard.new(payment_method: stripe_payment_method, address: Spree::Address.build_default)
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

  def use_billing_address # rubocop:disable Metrics/AbcSize
    payment_method_id = params.dig(:order, :payments_attributes).first[:payment_method_id]
    billing_address = params[:payment_source][payment_method_id][:address_attributes].except(:phone_without_code)
    billing_address = billing_address.permit(permitted_address_attributes)

    params[:order][:ship_address_attributes].merge!(billing_address)
  end
end

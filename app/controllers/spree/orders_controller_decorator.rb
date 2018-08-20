Spree::OrdersController.class_eval do
  include Spree::BaseHelper
  include ActionView::Helpers::TextHelper

  before_action :load_order, only: %i[show rate_shipment update_shipment_rate]
  before_action :load_shipment, only: %i[rate_shipment update_shipment_rate]

  # Storefront changes:
  # - respond to js when add to cart clicked

  # Adds a new item to the order (creating a new order if none already exists)
  def populate # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    order    = current_order(create_order_if_necessary: true)
    @variant = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(@variant, quantity, options)
        order.update_line_item_prices!
        order.create_tax_charge!
        order.update_with_updater!
      rescue ActiveRecord::RecordInvalid => e
        error = customize_populate_error(e)
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    product_name = @variant.product.name

    Tracker.track(mixpanel_user_id, 'item added to cart', order_id: order.id, product_id: @variant.id, product_name: product_name) if error.blank?

    respond_with(order) do |format|
      if params[:button] == 'add-to-cart'
        if error
          flash[:error] = error
        else
          flash[:success] = render_to_string(partial: 'spree/orders/added_to_cart', formats: [:html])
        end

        format.js
      else
        format.html { redirect_to(cart_path(variant_id: @variant.id)) }
      end
    end
  end

  def rate_shipment
    @account_tab = :orders
  end

  def update_shipment_rate # rubocop:disable Metrics/AbcSize
    rating = GlobalReputation::Api::Rating.rate_shipment(spree_current_user, @shipment, params[:rating], params[:review].presence)
    if rating.errors.blank?
      flash[:success] = t(rating.modification ? 'orders.updated_successfully' : 'orders.submitted_successfully')
      redirect_to(@shipment.order)
    else
      render :rate_shipment
    end
  end

  def show
    @account_tab = :orders
  end

  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        if params.key?(:checkout)
          @order.next if @order.cart?
          format.html { redirect_to checkout_path }
          format.js { render js: "window.location.href='#{checkout_path}'" }
        else
          format.html { redirect_to cart_path }
          format.js
        end
      end
    else
      flash[:error] = @order.errors.full_messages.join(', ')
      respond_with(@order.reload) do |format|
        format.html { redirect_to cart_path }
        format.js
      end
    end
  end

  private

  def load_order
    @order = Spree::Order.includes(line_items: [variant: %i[option_values images product]],
                                   bill_address: :state, ship_address: :state)
                         .find_by!(number: params[:id])
  end

  def load_shipment
    @shipment = @order.shipments.find_by!(number: params[:shipment_id])
  end

  def customize_populate_error(err)
    record = err.record
    errors = record.errors

    # quantity validation message is ovveriden only in controller
    # to show custom message only in controller
    if errors.include?(:quantity)
      variant = record.variant
      display_name = truncate(variant.name.to_s, length: 25)

      if (variant_options = variant.options_text).present?
        display_name += " (#{variant_options})"
      end

      Spree.t(:variant_quantity_not_available, title: display_name, available_items: variant.total_on_hand)
    else
      errors.full_messages.join(', ')
    end
  end
end
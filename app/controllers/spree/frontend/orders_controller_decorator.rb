Spree::OrdersController.class_eval do
  include Spree::BaseHelper
  include ActionView::Helpers::TextHelper

  skip_before_action :check_authorization, only: [:rate]

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

  def rate
    order = Spree::Order.find_by!(number: params[:id])
    authorize! :rate, order

    GlobalReputation::Api::Rating.rate_order(spree_current_user, order, params[:rating])
    Rails.cache.delete(order.rating_uid)

    redirect_to(order)
  end

  def show
    @order = Spree::Order.includes(line_items: [variant: %i[option_values images product]],
                                   bill_address: :state, ship_address: :state)
                         .find_by!(number: params[:id])

    return unless @order.rating_uid
    @rating = Rails.cache.fetch(@order.rating_uid) do
      GlobalReputation::Api::Rating.find(@order.rating_uid).first
    end
  end

  private

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

Spree::OrdersController.class_eval do
  # Bookstore changes:
  # - respond to js when add to cart clicked

  # Adds a new item to the order (creating a new order if none already exists)
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity, options)
        order.update_line_item_prices!
        order.create_tax_charge!
        order.update_with_updater!
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(', ')
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      respond_to do |format|
        format.html { redirect_back_or_default(spree.root_path) }
        format.js
      end
    else
      respond_with(order) do |format|
        if params[:button] == 'add-to-cart'
          flash[:success] = Spree.t(:added_to_cart, product: variant.product.name)
          format.js
        else
          format.html { redirect_to(cart_path(variant_id: variant.id)) }
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
end

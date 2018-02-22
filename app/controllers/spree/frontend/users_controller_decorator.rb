Spree::UsersController.class_eval do
  ORDERS_PER_USER_PAGE = 10

  # Bookstore changes:
  # - order pagination
  def show
    @account_tab = account_tab
    case @account_tab
    when :orders
      show_orders
    when :payment
      show_payment
    end
  end

  def update_address
    @user = spree_current_user
    address_params = fill_shipping_address
    if @user.update_attributes(address_params)
      redirect_to '/account/payment'
    else
      render :show
    end
  end

  # Bookstore changes:
  # - save(context: :edit)
  # - move sign_in to separate method
  def update
    @user.assign_attributes(user_params)
    if @user.save(context: :edit)
      sign_in_user if params[:user][:password].present?
      redirect_to spree.account_url, notice: Spree.t(:account_updated)
    else
      render :edit
    end
  end

  private

  def fill_shipping_address
    address_params = user_payment_params
    if billing_params[:use_billing] == '1'
      address_params[:ship_address_attributes] = {} unless address_params[:ship_address_attributes]
      address_params[:ship_address_attributes].merge!(address_params[:bill_address_attributes].except('id'))
      address_params[:ship_address_attributes].permit!
    end
    address_params
  end

  def user_payment_params
    params.require(:user).permit(
      bill_address_attributes: Spree::PermittedAttributes.address_attributes,
      ship_address_attributes: Spree::PermittedAttributes.address_attributes,
      credit_cards_attributes: [:id, :_destroy]
    )
  end

  def billing_params
    params.require(:order).permit(:use_billing)
  end

  def show_orders
    @orders = @user.orders
                   .complete
                   .order('completed_at desc')
                   .page(params[:page])
                   .per(ORDERS_PER_USER_PAGE)
  end

  def sign_in_user
    # this logic needed b/c devise wants to log us out after password changes
    Spree::User.reset_password_by_token(params[:user])

    if Spree::Auth::Config[:signout_after_password_change]
      sign_in(@user, event: :authentication)
    else
      bypass_sign_in(@user)
    end
  end

  def show_payment
    @user.bill_address ||= Spree::Address.build_default
    @user.ship_address ||= Spree::Address.build_default
    @eq_ship_address = (@user.bill_address.nil? && @user.ship_address.nil?) || @user.bill_address.same_as?(@user.ship_address)
  end

  def account_tab
    tab = [params[:tab].to_s.to_sym] & %i[summary orders payment]
    tab.first || :summary
  end
end

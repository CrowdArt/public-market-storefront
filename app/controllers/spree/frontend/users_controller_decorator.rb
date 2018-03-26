Spree::UsersController.class_eval do
  before_action :load_user, only: %i[show update_address update_password]
  before_action :hide_search_bar_on_mobile, only: %i[show edit]

  ORDERS_PER_USER_PAGE = 10

  def show
    @account_tab = account_tab

    set_back_mobile_link('/account') if @account_tab != :summary

    case @account_tab
    when :orders
      show_orders
    when :payment
      show_payment
    when :shipping
      show_shipping
    end
  end

  def update_address
    @account_tab = :shipping

    if @user.update(user_address_params)
      redirect_to "/account/#{@account_tab}"
    else
      render :show
    end
  end

  # Bookstore changes:
  # - save(context: :edit)
  def update
    @user.assign_attributes(user_params)
    if @user.save(context: :edit)
      notification_msg = @user.saved_change_to_unconfirmed_email? ? :account_email_updated : :account_updated
      redirect_to spree.account_url, notice: Spree.t(notification_msg)
    else
      render :edit
    end
  end

  def update_password
    @user.assign_attributes(user_password_params)
    if @user.save
      sign_in_user
      redirect_to spree.account_url, notice: Spree.t(:account_updated)
    else
      render :edit
    end
  end

  def edit
    set_back_mobile_link('/account')
  end

  private

  def load_user
    @user = spree_current_user
  end

  def user_address_params
    params.require(:user).permit(ship_address_attributes: Spree::PermittedAttributes.address_attributes)
  end

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
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
    @cards = @user.credit_cards
  end

  def show_shipping
    @user.ship_address ||= Spree::Address.build_default
  end

  def account_tab
    tab = [params[:tab].to_s.to_sym] & %i[summary orders payment shipping]
    tab.first || :summary
  end
end

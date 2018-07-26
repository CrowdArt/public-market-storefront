Spree::UsersController.class_eval do
  before_action :load_user, only: %i[show update_password]

  ORDERS_PER_USER_PAGE = 10

  def show
    @account_tab = account_tab

    case @account_tab
    when :orders
      show_orders
    end
  end

  # Storefront changes:
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

  private

  def load_user
    @user = spree_current_user
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

  def account_tab
    tab = [params[:tab].to_s.to_sym] & %i[summary orders]
    tab.first || :summary
  end
end

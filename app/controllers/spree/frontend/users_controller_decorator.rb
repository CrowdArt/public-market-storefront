Spree::UsersController.class_eval do
  ORDERS_PER_USER_PAGE = 10

  # Bookstore changes:
  # - order pagination
  def show
    @orders = @user.orders
                   .complete
                   .order('completed_at desc')
                   .page(params[:page])
                   .per(ORDERS_PER_USER_PAGE)
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

  def sign_in_user
    # this logic needed b/c devise wants to log us out after password changes
    Spree::User.reset_password_by_token(params[:user])

    if Spree::Auth::Config[:signout_after_password_change]
      sign_in(@user, event: :authentication)
    else
      bypass_sign_in(@user)
    end
  end
end

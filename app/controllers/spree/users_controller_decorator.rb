Spree::UsersController.class_eval do
  before_action :set_account_tab, only: %i[show edit]

  ORDERS_PER_USER_PAGE = 10

  def show
    case @account_tab
    when :orders
      show_orders
    end
  end

  # Storefront changes:
  # - save(context: :edit)
  def update # rubocop:disable Metrics/AbcSize
    # reload user to not mess with spree_current_user
    @user = Spree::User.friendly.find(params[:id])
    @user.assign_attributes(user_params)

    if @user.save(context: :edit)
      flash[:notice] = Spree.t(:account_updated)

      respond_to do |format|
        format.html { redirect_to spree.edit_account_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    spree_current_user.destroy
    flash[:danger] = t('users.account-deleted')
    redirect_to :root
  end

  private

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def show_orders
    @orders = @user.orders
                   .includes(:shipments, line_items: [variant: [:images, { product: :master }, :option_values]])
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

  def set_account_tab
    tab = [params[:tab].to_s.to_sym] & %i[summary orders]
    @account_tab = tab.first || :summary
  end

  def accurate_title
    Spree.t(:your_account)
  end
end

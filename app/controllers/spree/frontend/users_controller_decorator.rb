Spree::UsersController.class_eval do
  ORDERS_PER_USER_PAGE = 10

  def show
    @orders = @user.orders
                   .complete
                   .order('completed_at desc')
                   .page(params[:page])
                   .per(ORDERS_PER_USER_PAGE)
  end
end

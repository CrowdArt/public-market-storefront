Spree::UserSessionsController.class_eval do
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html do
          flash[:success] = Spree.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        end

        format.js do
          render json: {
            user: spree_current_user,
            ship_address: spree_current_user.ship_address,
            bill_address: spree_current_user.bill_address
          }.to_json
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = t('devise.failure.invalid')
          render :new
        end

        format.js do
          render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        end
      end
    end
  end
end

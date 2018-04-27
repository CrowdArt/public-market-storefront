Spree::UserSessionsController.class_eval do
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    authenticate_spree_user!

    if spree_user_signed_in?
      user = spree_current_user
      set_mixpanel_tracking(user)

      respond_to do |format|
        format.html do
          flash[:success] = Spree.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(user))
        end

        format.js do
          render json: {
            user: user,
            ship_address: user.ship_address,
            bill_address: user.bill_address
          }.to_json
        end
      end
    else
      respond_to do |format|
        format.html do
          set_user_with_errors
          render :new
        end

        format.js do
          render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_mixpanel_tracking(resource)
    session[:mixpanel_actions] = ["mixpanel.identify('#{resource.id}')"]

    session[:mixpanel_actions] << <<~JS
      mixpanel.people.set({
        "$first_name": "#{resource.first_name}",
        "$last_name": "#{resource.last_name}",
        "$email": "#{resource.try(:email)}",
        "$created": "#{resource.created_at}"
      })
    JS

    session[:mixpanel_actions] << <<~JS
      mixpanel.track('signin', {
        "user_id": "#{resource.id}",
        "email": "#{resource.try(:email)}"
      })
    JS
  end

  def set_user_with_errors
    @user = Spree::User.new
    @user.errors[:email] << t('devise.failure.invalid')
    @user.errors[:password] << t('devise.failure.invalid')
  end
end

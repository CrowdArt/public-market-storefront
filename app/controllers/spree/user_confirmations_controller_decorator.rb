Spree::UserConfirmationsController.class_eval do
  def create # rubocop:disable Metrics/AbcSize
    current_user_params = spree_user_signed_in? ? { email: spree_current_user.email } : resource_params

    self.resource = resource_class.send_confirmation_instructions(current_user_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      session[:mixpanel_actions] = [
        %(mixpanel.track("email confirmation sent", {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ]
      respond_with({}, { location: after_resending_confirmation_instructions_path_for(resource_name) })
    else
      respond_with(resource)
    end
  end

  def show # rubocop:disable Metrics/AbcSize
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    notification_msg = resource.saved_change_to_unconfirmed_email? ? :reconfirmed : :confirmed

    if resource.errors.empty?
      set_flash_message!(:notice, notification_msg)
      session[:mixpanel_actions] = [
        %(mixpanel.track("email confirmed", {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ]
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    spree_user_signed_in? ? account_path : new_session_path(resource_name)
  end

  def devise_i18n_options(options)
    email = resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email
    options.merge(email: email)
  end

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    signed_in?(resource_name) ? signed_in_root_path(resource) : spree.login_path
  end
end

Spree::UserPasswordsController.class_eval do
  skip_before_action :require_no_authentication, only: %i[create edit update]
  before_action :set_account_tab, only: :edit

  def create # rubocop:disable Metrics/AbcSize
    current_user_params = spree_user_signed_in? ? { email: spree_current_user.email } : resource_params
    self.resource = resource_class.send_reset_password_instructions(current_user_params)

    if resource.errors.empty?
      flash[:info] = I18n.t('devise.user_passwords.spree_user.send_instructions', email: resource.email)

      respond_with({}, { location: after_sending_reset_password_instructions_path_for(resource_name) })
    else
      respond_with(resource)
    end
  end

  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.new_record?
      flash[:error] = 'Incorrect token'
      redirect_to root_path
    elsif resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      session[:email] = resource.email
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def set_account_tab
    @account_tab = :summary
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    spree_user_signed_in? ? account_path : new_session_path(resource_name)
  end
end

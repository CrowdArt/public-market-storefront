Devise::ConfirmationsController.class_eval do
  def show # rubocop:disable Metrics/AbcSize
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    notification_msg = resource.saved_change_to_unconfirmed_email? ? :reconfirmed : :confirmed

    if resource.errors.empty?
      set_flash_message!(:notice, notification_msg)
      flash[:mixpanel_actions] = [
        %Q(mixpanel.track("email confirmed", {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ].to_json
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  def create # rubocop:disable Metrics/AbcSize
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:mixpanel_actions] = [
        %Q(mixpanel.track("email confirmation sent", {
          "user_id": "#{resource.id}",
          "email": "#{resource.try(:email)}"
        }))
      ].to_json
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
end

module Spree
  module UserRegistrationsControllerDecorator
    # POST /resource/sign_up
    # Storefront changes:
    # - save(context: :signup)
    def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @user = build_resource(spree_user_params)
      resource_saved = resource.save(context: :signup)
      yield resource if block_given?
      if resource_saved
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up
          sign_up(resource_name, resource)
          session[:spree_user_signup] = true
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
        session[:mixpanel_actions] = [
          "mixpanel.alias('#{resource.id}')",
          %(mixpanel.track('signup', {
            "user_id": "#{resource.id}",
            "email": "#{resource.try(:email)}",
          }))
        ]
      else
        clean_up_passwords(resource)
        render :new
      end
    end

    protected

    def set_flash_message(key, kind, options = {})
      super(key, kind, options.merge(email: resource&.email))
    end
  end

  UserRegistrationsController.prepend(UserRegistrationsControllerDecorator)
end

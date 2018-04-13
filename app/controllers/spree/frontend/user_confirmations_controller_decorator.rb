Spree::UserConfirmationsController.class_eval do
  protected

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    signed_in?(resource_name) ? signed_in_root_path(resource) : spree.login_path
  end
end

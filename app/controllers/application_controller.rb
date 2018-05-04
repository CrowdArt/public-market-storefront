class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  prepend_before_action :auth_staging, if: -> { Rails.env.staging? }
  before_action :set_raven_context, if: -> { Rails.env.staging? || Rails.env.production? }

  protected

  def mixpanel_user_id
    return spree_current_user if spree_current_user
    mp_params = cookies["mp_#{Settings.mixpanel_api_key}_mixpanel"]
    return if mp_params.blank?
    distinct_id = JSON.parse(mp_params)['distinct_id']
    distinct_id.presence
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def auth_staging
    authenticate_or_request_with_http_basic do |name, password|
      name == Settings.basic_auth_name && password == Settings.basic_auth_password
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

  private

  def set_raven_context
    return if !Rails.env.staging? && !Rails.env.production?
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end

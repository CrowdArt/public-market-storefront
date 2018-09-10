class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context, if: -> { Rails.env.staging? || Rails.env.production? }
  before_action :authenticate_user!, unless: :allow_unauthenticated_view?

  protected

  def mixpanel_user_id
    return spree_current_user if spree_current_user
    mp_params = cookies["mp_#{Rails.application.credentials.mixpanel_api_key}_mixpanel"]
    return if mp_params.blank?
    distinct_id = JSON.parse(mp_params)['distinct_id']
    distinct_id.presence
  end

  def authenticate_user!
    redirect_params = request.query_string.presence ? "?#{request.query_string}" : ''
    redirect_to "https://waitlist.public.market#{redirect_params}" if !spree_user_signed_in? && cookies['_skip_waitlist'].blank?
  end

  def allow_unauthenticated_view?
    return true if Rails.env.test?

    (controller_name == 'user_sessions' && action_name.in?(%w[new])) ||
      (controller_name == 'user_registrations' && action_name.in?(%w[new create]))
  end

  private

  def set_raven_context
    Raven.user_context(user_id: spree_current_user&.id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def save_return_to
    session[:spree_user_return_to] = request.referer
  end

  # prevents a bug where clicking the back button of the browser displays the JS response
  def add_vary_header
    response.headers['Vary'] = 'Accept' if request.xhr?
  end
end

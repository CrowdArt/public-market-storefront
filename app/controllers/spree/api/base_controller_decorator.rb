Spree::Api::BaseController.class_eval do
  def api_key
    request.headers['X-PM-Token'] || request.headers['X-Spree-Token'] || params[:token]
  end
end

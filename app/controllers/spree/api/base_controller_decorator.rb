Spree::Api::BaseController.class_eval do
  def api_key
    request.headers['X-PM-Token'] || super
  end
end

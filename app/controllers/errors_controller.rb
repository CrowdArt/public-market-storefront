class ErrorsController < Spree::StoreController
  def not_found
    render :common_error_page, status: 404
  end

  def internal_server_error
    render :common_error_page, status: 500
  end
end

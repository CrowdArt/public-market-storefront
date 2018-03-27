class ErrorsController < Spree::StoreController
  def not_found
    render :common_error_page, status: :not_found
  end

  def internal_server_error
    render :common_error_page, status: :internal_server_error
  end
end

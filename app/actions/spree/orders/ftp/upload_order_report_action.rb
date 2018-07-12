module Spree
  module Orders
    module Ftp
      class UploadOrderReportAction < Spree::BaseAction
        param :vendor
        param :ftp_key

        def call
          orders = FetchVendorOrdersAction.call(vendor)
          csv = create_report(orders)
          upload_to_ftp()
        end

        private

        def create_report(orders)
        end
      end
    end
  end
end

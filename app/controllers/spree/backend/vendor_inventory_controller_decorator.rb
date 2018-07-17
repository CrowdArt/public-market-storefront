module Spree
  module Admin
    module VendorInventoryControllerDecorator
      private

      def save_content
        @file_path = GCS::UploadFile.call(upload_params['attachment'].tempfile.path, upload_params['attachment'].original_filename)
      end
    end

    VendorInventoryController.prepend(VendorInventoryControllerDecorator)
  end
end

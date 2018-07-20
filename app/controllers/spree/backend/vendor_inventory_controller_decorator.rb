module Spree
  module Admin
    module VendorInventoryControllerDecorator
      private

      def save_content
        @file_path = GCS::UploadFile.call(
          @attachment.tempfile.path,
          @attachment.original_filename
        )
      end
    end

    VendorInventoryController.prepend(VendorInventoryControllerDecorator)
  end
end

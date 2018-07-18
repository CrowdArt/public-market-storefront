module Spree
  module Admin
    module VendorInventoryControllerDecorator
      private

      def save_content
        if Rails.env.development?
          super # save local tmp folder
        else
          @file_path = GCS::UploadFile.call(
            @attachment.tempfile.path,
            @attachment.original_filename
          )
        end
      end
    end

    VendorInventoryController.prepend(VendorInventoryControllerDecorator)
  end
end

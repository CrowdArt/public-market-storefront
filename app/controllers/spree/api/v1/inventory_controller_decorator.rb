module Spree
  module Api
    module V1
      module InventoryControllerDecorator
        private

        def save_content
          GCS::UploadFile.call(upload_params['attachment'].tempfile.path, upload_params['attachment'].original_filename)
        end
      end

      InventoryController.prepend(InventoryControllerDecorator)
    end
  end
end

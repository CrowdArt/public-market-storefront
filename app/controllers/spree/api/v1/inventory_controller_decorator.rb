module Spree
  module Api
    module V1
      module InventoryControllerDecorator
        private

        def save_content
          file = File.open("tmp/#{SecureRandom.urlsafe_base64}", 'w')
          file.write(request.body.read)
          file.close
          file_path = file.path

          GCS::UploadFile.call(file_path)
        end
      end

      InventoryController.prepend(InventoryControllerDecorator)
    end
  end
end

module Spree
  module Api
    module V1
      module InventoryControllerDecorator
        private

        def save_content
          file_path = super

          # use file in local tmp folder
          return file_path if Rails.env.development?

          GCS::UploadFile.call(file_path)
        end
      end

      InventoryController.prepend(InventoryControllerDecorator)
    end
  end
end

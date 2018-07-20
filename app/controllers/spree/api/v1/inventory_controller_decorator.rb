module Spree
  module Api
    module V1
      module InventoryControllerDecorator
        private

        def save_content
          GCS::UploadFile.call(super)
        end
      end

      InventoryController.prepend(InventoryControllerDecorator)
    end
  end
end

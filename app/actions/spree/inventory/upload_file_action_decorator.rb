module Spree
  module Inventory
    module UploadFileActionDecorator
      def assign_default_meta
        upload_meta[:product_type] ||= 'books'
        # upload file to gcloud before processing
        upload_meta[:file_path] = GCS::UploadFile.call(upload_meta[:file_path], '.' + upload_meta[:format])
      end
    end

    UploadFileAction.prepend(UploadFileActionDecorator)
  end
end

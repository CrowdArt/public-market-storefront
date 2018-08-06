module Spree
  module Inventory
    module UploadFileActionDecorator
      def assign_default_meta # rubocop:disable Metrics/AbcSize
        upload_meta[:product_type] ||= 'books'
        # upload file to gcloud before processing
        opts = {
          folder: ['inventory', upload_meta[:vendor_id]].join('/')
        }

        opts[:original_filename] =
          if upload_meta[:original_name]
            [Time.current.to_i, upload_meta[:original_name]].join('-')
          else
            [Time.current.to_i, SecureRandom.hex(5)].join('-') + '.' + upload_meta[:format]
          end

        upload_meta[:file_path] = GCS::UploadFile.call(upload_meta[:file_path], opts)
      end
    end

    UploadFileAction.prepend(UploadFileActionDecorator)
  end
end

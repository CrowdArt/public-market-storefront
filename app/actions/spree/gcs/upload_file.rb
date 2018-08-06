module Spree
  module GCS
    class UploadFile < GCS::BaseAction
      param :file_path
      option :original_filename, optional: true
      option :folder, optional: true

      def call
        upload
      end

      private

      def upload
        file = bucket.create_file(file_path, file_name)
        file.name
      end

      def file_name
        filename = original_filename || [Time.current.to_i, SecureRandom.hex(5)].join('-')
        [folder, filename].compact.join('/')
      end
    end
  end
end

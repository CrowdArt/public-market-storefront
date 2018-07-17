module Spree
  module GCS
    class UploadFile < GCS::BaseAction
      param :file_path
      param :original_filename, optional: true

      def call
        upload
      end

      private

      def upload
        file = bucket.create_file(file_path, file_name)
        file.name
      end

      def file_name
        [Time.current.to_i, SecureRandom.hex(5), original_filename].join('-')
      end
    end
  end
end

module Spree
  module GCS
    class DownloadFile < GCS::BaseAction
      param :file_path
      param :path, optional: true, default: proc { nil }

      def call
        download
      end

      private

      def download
        file = bucket.file(file_path)
        file.download(path)
      end
    end
  end
end

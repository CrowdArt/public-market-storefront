module Spree
  module UploadInventoryWorkerDecorator
    private

    def load_file(filepath)
      # filepath = file name in bucket with uploads in GCS
      GCS::DownloadFile.call(filepath, "tmp/#{filepath}")
    end
  end

  UploadInventoryWorker.prepend(UploadInventoryWorkerDecorator)
end

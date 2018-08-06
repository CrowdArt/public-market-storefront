module Spree
  module UploadInventoryWorkerDecorator
    private

    def load_file(filepath)
      # filepath in google can be folder structure, use tmp name
      tmp_file_path = [:inventory, Time.current.to_i, SecureRandom.hex(5)].join('-')
      # filepath = file name in bucket with uploads in GCS
      GCS::DownloadFile.call(filepath, "tmp/#{tmp_file_path}")
    end
  end

  UploadInventoryWorker.prepend(UploadInventoryWorkerDecorator)
end

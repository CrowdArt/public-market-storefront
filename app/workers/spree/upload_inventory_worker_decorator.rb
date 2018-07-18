module Spree
  module UploadInventoryWorkerDecorator
    def perform(upload_id, format, filepath, opts = {})
      @upload = Upload.find_by(id: upload_id)

      local_file = load_file(filepath)
      upload_action(format, local_file, opts)
    end

    private

    def load_file(filepath)
      if Rails.env.production? || Rails.env.staging?
        # filepath = file name in bucket with uploads in GCS
        GCS::DownloadFile.call(filepath, "tmp/#{filepath}")
      else
        filepath
      end
    end
  end

  UploadInventoryWorker.prepend(UploadInventoryWorkerDecorator)
end

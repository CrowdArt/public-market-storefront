module Spree
  module GCS
    require 'google/cloud/storage'

    class BaseAction < Spree::BaseAction
      private

      def storage
        @storage ||= Google::Cloud::Storage.new(
          project_id: Rails.application.credentials.google_project,
          credentials: YAML.safe_load(Rails.application.credentials.google_json_key_string)
        )
      end

      def bucket
        @bucket ||= storage.bucket(Rails.application.credentials.google_uploads_bucket)
      end
    end
  end
end

class InventoryUpload < ApplicationRecord
  include InventoryUploader::Attachment.new(:upload)
end

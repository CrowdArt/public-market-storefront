require 'rails_helper'

RSpec.describe InventoryUpload, type: :model do
  describe '#shrine' do
    subject(:upload) { InventoryUpload.create(upload: File.open(filepath, 'r')) }

    let(:filepath) { File.join(Dir.pwd, 'spec/fixtures/files', 'book_upload.csv') }

    it { pp upload.upload.download }
  end
end

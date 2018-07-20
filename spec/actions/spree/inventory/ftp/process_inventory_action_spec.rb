RSpec.describe Spree::Inventory::Ftp::ProcessInventoryAction, type: :action do
  subject(:call) { action.call }

  let(:action) { described_class.new(vendor, :test_ftp) }
  let(:vendor) { build_stubbed(:vendor) }
  let(:file) { file_fixture('ftp_upload.txt') }

  describe '#call' do
    before do
      allow(action).to receive(:each_ftp_file) do |&block|
        block.call(file)
      end

      allow(Spree::GCS::UploadFile).to receive(:call).and_return('filepath')
      allow(Spree::Inventory::UploadFileAction).to receive(:call)

      call
    end

    it 'calls UploadFileAction' do
      expect(Spree::Inventory::UploadFileAction).to have_received(:call).with(
        'csv_tab',
        'filepath',
        provider: 'bwb',
        product_type: 'books',
        upload_options: { vendor_id: vendor.id }
      )
    end
  end
end

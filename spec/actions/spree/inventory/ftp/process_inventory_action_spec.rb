RSpec.describe Spree::Inventory::Ftp::ProcessInventoryAction, type: :action do
  subject(:call) { action.call }

  let(:action) { described_class.new(vendor, :test_ftp) }
  let(:vendor) { build_stubbed(:vendor) }
  let(:file) { file_fixture('ftp_upload.txt') }

  describe '#call' do
    before do
      allow(action).to receive(:each_ftp_file) do |&block|
        block.call('original_name', file)
      end

      allow(Spree::Inventory::UploadFileAction).to receive(:call)

      call
    end

    it 'calls UploadFileAction' do
      expect(Spree::Inventory::UploadFileAction).to have_received(:call).with(
        format: 'csv_tab',
        file_path: file,
        original_name: 'original_name',
        provider: 'bwb',
        product_type: 'books',
        vendor_id: vendor.id
      )
    end
  end
end

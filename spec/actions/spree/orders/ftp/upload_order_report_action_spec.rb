RSpec.describe Spree::Orders::Ftp::UploadOrderReportAction, type: :action do
  subject(:result) { File.open(action.call).read }

  let(:action) { described_class.new(vendor, :test_ftp, skip_ftp_upload: true) }
  let(:order) { create(:completed_vendor_order) }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }

  it { expect(result).to match(line_item.variant.sku) }
  it { expect(result).to match("\t") }

  context 'when line item has quantity more than one' do
    before { line_item.update_column(:quantity, 3) }

    it { expect(result.scan(line_item.variant.sku).size).to eq(3) }
  end
end

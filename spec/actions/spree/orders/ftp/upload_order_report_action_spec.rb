RSpec.describe Spree::Orders::Ftp::UploadOrderReportAction, type: :action do
  subject(:result) { File.open(action.call).read }

  let(:action) { described_class.new(vendor, :test_ftp, skip_ftp_upload: true) }
  let(:order) { create(:completed_vendor_order) }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }

  it { expect(result).to match(line_item.variant.sku) }
  it { expect(result).to match("\t") }

  context 'when line item has quantity more than one' do
    before do
      line_item.variant.stock_items.first.set_count_on_hand(3)
      line_item.update!(quantity: 3)
    end

    it { expect(result.scan(line_item.variant.sku).size).to eq(3) }

    it 'includes all units' do
      order.inventory_units.each do |unit|
        expect(result).to match(unit.hash_id)
      end
    end
  end
end

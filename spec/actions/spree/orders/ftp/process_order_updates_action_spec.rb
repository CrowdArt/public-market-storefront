RSpec.describe Spree::Orders::Ftp::ProcessOrderUpdatesAction, type: :action do
  subject(:call) { action.call }

  let(:action) { described_class.new(vendor, :test_ftp) }
  let(:order) { create(:vendor_order_ready_to_ship, line_items_count: 2) }
  let(:line_item) { order.line_items.first }
  let(:unit) { line_item.inventory_units.first }
  let(:vendor) { line_item.variant.vendor }
  let(:columns) { %i[ABEPOID ABEPOITEMID STATUS] }
  let(:file) do
    file = Tempfile.new
    CSV.open(file, 'wb', col_sep: "\t",
                         headers: columns,
                         force_quotes: false,
                         write_headers: true) do |csv|
      updates.each { |u| csv << u }
    end
    file
  end

  describe 'update logic' do
    before do
      allow(action).to receive(:each_ftp_update_file) do |&block|
        block.call(file)
      end
    end

    context 'when confirm' do
      let(:updates) { [{ ABEPOID: order.hash_id, ABEPOITEMID: unit.hash_id, STATUS: 'Confirm' }] }

      it { expect { call }.to change { unit.reload.state }.from('on_hand').to('shipped') }
    end

    context 'when cancel' do
      let(:updates) { [{ ABEPOID: order.hash_id, ABEPOITEMID: unit.hash_id, STATUS: 'Cancel' }] }

      it { expect { call }.to change { unit.reload.state }.from('on_hand').to('canceled') }
    end

    context 'when ship' do
      let(:columns) { %i[ABEPOID ABEPOITEMID STATUS DATESHIPPED TRACKINGNUMBER] }
      let(:updates) do
        [
          { ABEPOID: order.hash_id, ABEPOITEMID: unit.hash_id, STATUS: 'Confirm', DATESHIPPED: '2018-02-03 20:18:42', TRACKINGNUMBER: '123' }
        ]
      end

      before { call }

      it { expect(unit.reload.state).to eq('shipped') }
      it { expect(unit.shipment.state).to eq('shipped') }
      it { expect(unit.shipment.tracking).to be_truthy }
    end
  end

  describe 'each_ftp_update_file', skip: true do
    let(:ftp) { PublicMarket::FTP.new(:test_ftp, debug: false) }
    let(:updates) { [{ ABEPOID: order.hash_id, ABEPOITEMID: unit.hash_id, STATUS: 'Confirm' }] }

    before do
      ftp.mkdir('Confirm')
      ftp.put(file, 'Confirm/orders-update.tab')
      ftp.close
    end

    it { expect { call }.to change { unit.reload.state }.from('on_hand').to('confirmed') }
  end
end

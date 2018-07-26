RSpec.describe Spree::InventoryUnit, type: :model do
  describe 'hash_id' do
    let(:unit) { create(:inventory_unit) }

    it { expect(unit.hash_id.to_i).to be > 0 }
    it { expect(described_class.decoded_id(unit.hash_id)).to eq(unit.id) }
    it { expect(described_class.find_by_hash_id(unit.hash_id)).to eq(unit) } # rubocop:disable Rails/DynamicFindBy
  end

  describe 'state machine' do
    subject(:state) { unit.state }

    let(:unit) { create(:inventory_unit) }

    it { is_expected.to eq('on_hand') }

    context 'when cancel' do
      before { unit.cancel! }

      it { is_expected.to eq('canceled') }
      it { expect(unit.line_item.quantity).to eq(0) }
    end

    context 'when ship' do
      before { unit.ship! }

      it { is_expected.to eq('shipped') }
    end
  end

  describe 'create units for each quantity' do
    let(:quantity) { 5 }
    let(:order) { create(:order_with_vendor_items, line_items_quantity: quantity) }
    let(:line_item) { order.line_items.first }


    it { expect(line_item.inventory_units.count).to eq(quantity) }
    it { expect(line_item.inventory_units.first.quantity).to eq(1) }
  end
end

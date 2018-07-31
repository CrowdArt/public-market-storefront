RSpec.describe Spree::Order, type: :model do
  describe 'ability' do
    subject(:ability) { Spree::Ability.new(order.user) }

    let(:user) { create :user }
    let(:order) { create :order, user: user }

    it { expect(ability.can?(:rate, order)).to be_truthy } # rubocop:disable RSpec/PredicateMatcher
  end

  describe 'hash_id' do
    let(:order) { create(:order) }

    it { expect(order.hash_id.to_i).to be > 0 }
    it { expect(described_class.decoded_id(order.hash_id)).to eq(order.id) }
    it { expect(described_class.find_by_hash_id(order.hash_id)).to eq(order) } # rubocop:disable Rails/DynamicFindBy
  end

  describe 'cancel' do
    let(:order) { create(:vendor_order_ready_to_ship, line_items_count: 3) }

    context 'when all line units are canceled' do
      before { order.inventory_units.each(&:cancel!) }

      it { expect(order.reload.state).to eq('canceled') }
    end

    context 'when one line unit is canceled' do
      before { order.inventory_units.first.cancel! }

      it { expect(order.reload.state).to eq('complete') }
    end
  end

  describe 'finalize line items' do
    let(:order) { create(:order_with_vendor_items) }
    let(:line_item) { order.line_items.first }

    it { expect(line_item.rewards).to be_nil }

    context 'when complete' do
      before do
        allow_any_instance_of(Spree::Payment).to receive(:process!).and_return(true)
        create(:payment, amount: order.total, order: order)
        order.reload.transition_to_complete!
      end

      it { expect(line_item.rewards).to be_truthy }
    end
  end
end

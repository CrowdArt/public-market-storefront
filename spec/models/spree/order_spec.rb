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
    it { expect(described_class.find_by_hash_id(order.hash_id)).to eq(order) }
  end
end

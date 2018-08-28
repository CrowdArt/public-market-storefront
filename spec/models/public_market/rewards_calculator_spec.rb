RSpec.describe PublicMarket::RewardsCalculator, type: :model do
  subject(:value) { described_class.call(price, rewards) }

  describe '#to_s' do
    context 'when 2 decimals' do
      let(:price) { 1.55 }
      let(:rewards) { 1 }

      it { expect(value).to eq(0.2583333333) }
      it { expect(value.to_s).to eq('0.26') }
    end

    context 'when 1 decimal' do
      let(:price) { 91.55 }
      let(:rewards) { 1 }

      it { expect(value).to eq(15.25833333) }
      it { expect(value.to_s).to eq('15.3') }
    end

    context 'when zero decimals' do
      let(:price) { 191.55 }
      let(:rewards) { 10 }

      it { expect(value).to eq(319.25) }
      it { expect(value.to_s).to eq('319') }
    end
  end
end

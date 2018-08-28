RSpec.describe PublicMarket::RewardsCalculator, type: :model do
  subject(:value) { described_class.call(price, rewards) }

  describe '#to_s' do
    context 'when 2 decimals' do
      let(:price) { 91.55 }
      let(:rewards) { 1 }

      it { expect(value).to eq(0.9155) }
      it { expect(value.to_s).to eq('0.92') }
    end

    context 'when 1 decimal' do
      let(:price) { 191.55 }
      let(:rewards) { 10 }

      it { expect(value).to eq(19.155) }
      it { expect(value.to_s).to eq('19.2') }
    end

    context 'when zero decimals' do
      let(:price) { 1910.55 }
      let(:rewards) { 10 }

      it { expect(value).to eq(191.055) }
      it { expect(value.to_s).to eq('191') }
    end
  end
end

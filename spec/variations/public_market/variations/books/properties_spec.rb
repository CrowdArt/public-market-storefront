RSpec.describe PublicMarket::Variations::Books::Properties do
  describe '#variation_properties' do
    subject { described_class.variation_properties(product) }

    let(:product) { create(:product) }

    context 'when product has no format' do
      it { is_expected.to eq ['other'] }
    end

    context 'when product has format' do
      before do
        product.set_property(:format, format)
      end

      context 'when product has single format' do
        let(:format) { 'Perfect' }

        context 'when it is known format' do
          it { is_expected.to eq ['paperback'] }
        end

        context 'when it is unknown format' do
          let(:format) { 'Unknown format' }

          it { is_expected.to eq ['other'] }
        end
      end

      context 'when product has multiple formats' do
        let(:format) { 'Trade Paper; Trade Cloth; Mixed Audio' }

        it { is_expected.to eq %w[trade-paperback] }

        context 'when other is first' do
          let(:format) { 'Mixed Audio; Trade Paper; Trade Cloth' }

          it { is_expected.to eq %w[trade-paperback] }
        end
      end
    end
  end
end

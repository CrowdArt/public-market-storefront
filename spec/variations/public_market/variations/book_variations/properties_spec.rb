RSpec.describe PublicMarket::Variations::BookVariation::Properties do
  describe '#variation_properties' do
    subject { described_class.variation_properties(product) }

    let(:product) { create(:product) }

    context 'when product has no format' do
      it { is_expected.to eq nil }
    end

    context 'when product has format' do
      before do
        product.set_property(:format, format)
      end

      context 'when product has single format' do
        let(:format) { 'Paperback' }

        context 'when it is known format' do
          it { is_expected.to eq ['Paperback'] }
        end

        context 'when it is unknown format' do
          let(:format) { 'Unknown format' }

          it { is_expected.to eq ['Other'] }
        end
      end

      context 'when product has multiple formats' do
        let(:format) { 'Paperback; Trade Cloth; Mixed Audio' }

        it { is_expected.to eq %w[Paperback Hardcover Other] }
      end
    end
  end
end

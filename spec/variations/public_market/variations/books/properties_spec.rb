RSpec.describe PublicMarket::Variations::Books::Properties do
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
        let(:format) { 'Trade Paper' }

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

        it { is_expected.to eq %w[paperback] }

        context 'when other is first' do
          let(:format) { 'Mixed Audio; Trade Paper; Trade Cloth' }

          it { is_expected.to eq %w[paperback] }
        end
      end
    end
  end

  describe '#subtitle' do
    subject { described_class.subtitle(product) }

    let(:product) { create(:product) }

    context 'when product has no author' do
      it { is_expected.to eq nil }
    end

    context 'when product has author' do
      let(:author) { FFaker::Book.author }

      before { product.set_property(:author, author) }

      it { is_expected.to eq(author) }
    end
  end

  describe '#additional_properties' do
    subject { described_class.additional_properties(product) }

    let(:product) { create(:product) }

    context 'when product has no edition' do
      it { is_expected.to be_empty }
    end

    context 'when product has edition' do
      let(:edition) { '1th Edition' }

      before { product.set_property(:edition, edition) }

      it { is_expected.to eq([edition]) }
    end
  end
end

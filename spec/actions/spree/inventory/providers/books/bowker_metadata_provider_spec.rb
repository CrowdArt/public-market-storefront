RSpec.describe Spree::Inventory::Providers::Books::BowkerMetadataProvider, type: :action, vcr: true do
  subject(:properties) { metadata[:properties] }

  let(:metadata) { described_class.call(isbn) }

  context 'with known isbn' do
    let(:isbn) { '9780307341570' }

    it { expect(properties).to include(isbn: isbn) }
    it { expect(metadata[:title]).not_to be_empty }
    it { expect(metadata[:description]).not_to be_empty }
    it { expect(metadata[:dimensions]).not_to be_empty }
    it { expect(metadata[:price]).to be > 0 }
    it { expect(properties[:language]).not_to be_nil }
    it { expect(properties[:pages]).not_to be_nil }

    it 'contains correct taxons' do
      expect(metadata[:taxons]).to include(
        %w[FICTION Thrillers Suspense],
        %w[THRILLER SUSPENSE],
        ['FICTION', 'Family Life', 'Siblings'],
        %w[FICTION Crime]
      )
    end

    context 'with images', images: true do
      it { expect(metadata[:images]).not_to be_empty }
    end
  end

  context 'with unknown isbn' do
    let(:isbn) { '9780747545576' }

    it { expect(metadata).to be_blank }
  end

  context 'with empty binding' do
    let(:isbn) { '9780159016695' }

    it 'returns empty binding' do
      expect(metadata[:format]).to be_nil
    end
  end
end

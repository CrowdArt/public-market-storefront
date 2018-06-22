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
    it { expect(metadata[:taxons]).to include('Fiction', 'Thrillers', 'Suspense') }
    it { expect(metadata[:images]).not_to be_empty }
  end

  context 'with unknown isbn' do
    let(:isbn) { '9780747545576' }

    it { expect(metadata).to be_nil }
  end

  describe 'taxons logic' do
    subject(:taxons) { metadata[:taxons] }

    context 'with 9780439376105' do
      let(:isbn) { '9780439376105' }

      it { is_expected.to include('Juvenile fiction', 'Action & adventure', 'General') }
    end
  end
end

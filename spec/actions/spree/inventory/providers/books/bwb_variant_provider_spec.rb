RSpec.describe Spree::Inventory::Providers::Books::BwbVariantProvider, type: :action, vcr: true do
  subject(:variant) { described_class.call(item_json) }

  let(:item_json) do
    {
      isbn: isbn,
      bookid: 'SKU',
      quantity: '1',
      price: '9.61',
      condition: 'Collectible - Acceptable',
      title: 'Book Title',
      author: 'Book Author',
      description: 'Great book',
      publisher: 'Great Publisher'
    }
  end

  let(:isbn) { '9780307341570' }

  describe 'variant' do
    it { expect(variant.product).not_to be_nil }
    it { expect(variant.product).to be_persisted }
    it { expect(variant).not_to be_nil }
    it { expect(variant.sku).to eq(item_json[:bookid]) }
    it { expect(variant.notes).to eq(item_json[:description]) }

    describe 'condition' do
      it { expect(variant.option_value('condition')).to eq('Collectible - Acceptable') }
    end
  end

  describe 'validation' do
    let(:item_json) { { bookid: 'sku' } }

    it do
      # rubocop:disable Style/StringLiterals
      expect { variant }.to raise_error(Spree::ImportError).with_message(include(":condition=>[\"is missing\"", 'Collectible - Acceptable'))
      # rubocop:enable Style/StringLiterals
    end
  end

  describe 'metadata' do
    subject(:product) { variant.product }

    context 'with known isbn' do
      it { expect(product.name).not_to eq(item_json[:title]) }
      it { expect(product.description).not_to eq(item_json[:description]) }
      it { expect(product.property(:author)).not_to eq(item_json[:author]) }
      it { expect(product.property(:publisher)).not_to eq(item_json[:publisher]) }
    end

    context 'with unknown isbn' do
      let(:isbn) { '9780747545576' }

      it { expect(product.name).to eq(item_json[:title]) }
      it { expect(product.description).not_to eq(item_json[:description]) }
      it { expect(product.property(:author)).to eq(item_json[:author]) }
      it { expect(product.property(:isbn)).to eq(item_json[:isbn]) }
      it { expect(product.property(:publisher)).to eq(item_json[:publisher]) }
    end
  end
end

RSpec.describe Spree::Inventory::Providers::Books::BwbVariantProvider, type: :action, vcr: true do
  subject(:variant) { described_class.call(item_json) }

  let(:item_json) do
    {
      ean: isbn,
      sku: 'SKU',
      quantity: '1',
      price: '9.61',
      condition: 'Collectible - Acceptable',
      notes: 'A book with obvious wear.'
    }
  end

  let(:isbn) { '9780307341570' }

  describe 'validation' do
    let(:item_json) { { sku: 'sku' } }

    it do
      # rubocop:disable Style/StringLiterals
      expect { variant }.to raise_error(Spree::ImportError).with_message(include(":condition=>[\"is missing\"", 'Collectible - Acceptable'))
      # rubocop:enable Style/StringLiterals
    end
  end

  context 'with known isbn' do
    subject(:product) { variant.product }

    it { expect(product).not_to be_nil }
    it { expect(product).to be_persisted }

    describe 'variant' do
      it { expect(variant).not_to be_nil }

      describe 'condition' do
        it { expect(variant.option_value('condition')).to eq('Collectible - Acceptable') }
      end
    end
  end
end

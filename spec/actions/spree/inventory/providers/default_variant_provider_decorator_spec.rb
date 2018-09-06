RSpec.describe Spree::Inventory::Providers::Books::VariantProvider, type: :action, vcr: true do
  subject(:variant) { described_class.call(item_json) }

  let(:isbn) { '9780979728303' }
  let(:item_json) do
    {
      ean: isbn,
      sku: '08-F-002387',
      condition: 'Acceptable',
      seller: 'Computer Store',
      quantity: 1,
      price: 1.25
    }
  end

  describe '#build_new_product' do
    context 'with empty title' do
      let(:isbn) { '9780739421000' }

      it 'makes product not available' do
        expect(variant.product.name).to eq Spree::Product::MISSING_TITLE
        expect(variant.product.should_index?).to be false
      end
    end
  end

  describe '#update_variant_hook' do
    it 'sets seller to variant' do
      expect(variant.reload.seller).to eq(item_json[:seller])
    end
  end

  describe '#categorize' do
    it 'creates filterable taxonomy dy default' do
      expect(variant.product.taxonomy.filterable).to be true
      expect(variant.product.taxons).not_to be_empty
    end
  end
end

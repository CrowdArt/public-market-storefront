RSpec.describe Spree::Inventory::Providers::Books::VariantProvider, type: :action, vcr: true do
  subject(:variant) { described_class.call(item_json) }

  let(:item_json) do
    {
      ean: isbn,
      sku: 'SKU',
      quantity: '1',
      price: '9.61',
      condition: 'Acceptable',
      notes: 'A book with obvious wear.'
    }
  end

  let(:isbn) { '9780307341570' }

  it 'create product and variant' do # rubocop:disable RSpec/MultipleExpectations
    expect(variant).not_to be_nil
    expect(variant.sku).to eq(item_json[:sku])
    expect(variant.option_value('condition')).to eq(item_json[:condition])
    expect(variant.price).to be > 0
    expect(variant.total_on_hand).to eq(1)
    expect(variant.product.name).to eq('Dark Places')
    expect(variant.product.images.count).to eq(1)
    expect(variant.product.property(:author)).to eq('Gillian Flynn')
    expect(variant.product.property(:language)).to eq('English')
    expect(variant.product.property(:pages)).to eq('368')
    taxons = variant.product.taxons
    expect(taxons.count).to eq(1)
    expect(taxons.first.pretty_name).to eq('Categories -> Fiction -> Thrillers -> Suspense')
  end

  context 'with empty subject' do
    let(:isbn) { '9781600421570' }

    it 'does not create additional taxons' do
      expect(variant).not_to be_nil
      taxons = variant.product.taxons
      expect(taxons.count).to eq(1)
      expect(taxons.first.pretty_name).to eq('Categories')
    end
  end

  context 'with multiple details' do
    let(:isbn) { '9781423204237' }

    it 'saves variant' do
      expect(variant).not_to be_nil
    end
  end

  context 'with duplicate bindings' do
    let(:isbn) { '9780321692405' }

    it 'saves variant' do
      expect(variant.product.property(:format)).to eq('Mixed Media; Print, Other; Trade Paper; Trade Cloth')
    end
  end

  context 'with round brackets in subject' do
    let(:isbn) { '9780807823767' }

    it 'saves variant' do
      expect(variant).not_to be_nil
      taxons = variant.product.taxons
      expect(taxons.count).to eq(1)
      expect(taxons.first.pretty_name).to eq('Categories -> Charlotte (n.c.)')
    end
  end

  describe 'product images' do
    context 'with empty image' do
      let(:isbn) { '9780253202505' }

      it 'does not save image' do
        expect(variant).not_to be_nil
        expect(variant.product.images.count).to eq(0)
      end
    end

    context 'with not readable tempfile' do
      let(:isbn) { '9780321532015' }

      it 'saves image' do
        expect(variant).not_to be_nil
        expect(variant.product.images.count).to eq(1)
      end
    end
  end
end

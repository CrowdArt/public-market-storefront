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

  describe 'validation' do
    let(:item_json) { { sku: 'sku' } }

    it do
      expect { variant }.to raise_error(Spree::ImportError).with_message(include(":ean=>[\"is missing\"]")) # rubocop:disable Style/StringLiterals
    end
  end

  context 'with unknown isbn' do
    let(:isbn) { '0000000000000' }

    it { expect { variant }.to raise_error(Spree::ImportError, 'Unknown ISBN found') }
  end

  context 'with known isbn' do
    subject(:product) { variant.product }

    it { expect(product).not_to be_nil }
    it { expect(product).to be_persisted }
    it { expect(product.width).not_to be_nil }
    it { expect(product.available_on).not_to be_nil }
    it { expect(product.description).not_to be_nil }
    it { expect(product.properties.count).to eq(8) }
    it { expect(product.properties.first.presentation).to eq('ISBN') }
    it { expect(product.properties.last.presentation).to eq('Book subject') }
    it { expect(product.option_types.count).to eq(1) }
    it { expect(product.variants.count).to eq(1) }
    it { expect(product.property(:author)).not_to be_nil }
    it { expect(product.property(:published_at)).not_to be_nil }
    it { expect(product.properties.where(name: 'empty').first).to be_nil }
    it { expect(product.taxons.count).to eq(1) }
    it { expect(product.taxons.first.taxonomy.name).to eq('Books') }

    it { expect(variant).not_to be_nil }
    it { expect(variant).not_to eq(product.master) }
    it { expect(variant.sku).to eq(item_json[:sku]) }
    it { expect(variant.option_value('condition')).to eq(item_json[:condition]) }
    it { expect(variant.price).to eq(item_json[:price]) }
    it { expect(variant.cost_price).to eq(item_json[:price]) }
    it { expect(variant.total_on_hand).to eq(1) }

    context 'with images', vcr: true, images: true do
      it { expect(product.images.count).to eq(1) }
    end
  end

  describe 'taxonomy' do
    let(:taxonomy) { create(:taxonomy, name: 'Books') }

    before do
      fiction = create(:taxon, name: 'Fiction', taxonomy: taxonomy)
      thrillers = create(:taxon, name: 'Thrillers', parent_id: fiction.id, taxonomy: taxonomy)
      create(:taxon, name: 'Suspense', parent_id: thrillers.id, taxonomy: taxonomy)
    end

    it 'create product and variant' do
      expect(variant).not_to be_nil

      taxons = variant.product.taxons
      expect(taxons.count).to eq(1)
      expect(taxons.first.pretty_name).to eq('Books -> Fiction -> Thrillers -> Suspense')
    end

    context 'with incomplete existing taxonomy' do
      before do
        cooking = create(:taxon, name: 'Cooking', taxonomy: taxonomy)
        beverages = create(:taxon, name: 'Beverages', parent_id: cooking.id, taxonomy: taxonomy)
        create(:taxon, name: 'Alcoholic', parent_id: beverages.id, taxonomy: taxonomy)
      end

      let(:isbn) { '9781563054341' }

      it 'assigns to last matched taxon' do
        expect(variant).not_to be_nil
        product = variant.product

        expect(product.property('book_subject')).to include('COOKING / Beverages / Alcoholic / Wine')

        taxons = product.taxons
        expect(taxons.count).to eq(1)
        expect(taxons.first.pretty_name).to eq('Books -> Cooking -> Beverages -> Alcoholic')
      end
    end
  end

  context 'with empty subject' do
    let(:isbn) { '9781600421570' }

    it 'does not create additional taxons' do
      expect(variant).not_to be_nil
      taxons = variant.product.taxons
      expect(taxons.count).to eq(1)
      expect(taxons.first.pretty_name).to eq('Books -> Uncategorized')
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

  describe 'product images', images: true do
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

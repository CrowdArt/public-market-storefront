RSpec.describe Spree::Inventory::Providers::BowkerMetadataProvider, type: :action, vcr: true, vcr_proxy: true do
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

  describe 'default variant provider integration' do
    subject(:variant) { Spree::Inventory::Providers::DefaultVariantProvider.call(item_json) }

    let(:item_json) do
      {
        ean: '9780307341570',
        sku: 'SKU',
        quantity: '1',
        price: '9.61',
        condition: 'Acceptable',
        notes: 'A book with obvious wear.'
      }
    end

    it { expect(Spree::Config.product_metadata_provider.constantize).to eq(described_class) }

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
      let(:item_json) do
        {
          condition: 'Good',
          ean: '9781600421570',
          notes: 'Good copy ready to ship same',
          price: '69.83',
          quantity: 2,
          sku: 'PMI-3-ING-2400029166561'
        }
      end

      it 'does not create additional taxons' do
        expect(variant).not_to be_nil
        taxons = variant.product.taxons
        expect(taxons.count).to eq(1)
        expect(taxons.first.pretty_name).to eq('Categories')
      end
    end

    describe 'product images' do
      context 'with empty image' do
        let(:item_json) do
          {
            condition: 'Good',
            ean: '9780253202505',
            notes: 'Good copy ready to ship same',
            price: '69.83',
            quantity: 2,
            sku: 'SKU'
          }
        end

        it 'does not save image' do
          expect(variant).not_to be_nil
          expect(variant.product.images.count).to eq(0)
        end
      end

      context 'with not readable tempfile' do
        let(:item_json) do
          {
            condition: 'Good',
            ean: '9780321532015',
            notes: 'Good copy ready to ship same',
            price: '69.83',
            quantity: 2,
            sku: 'SKU'
          }
        end

        it 'saves image' do
          expect(variant).not_to be_nil
          expect(variant.product.images.count).to eq(1)
        end
      end
    end
  end
end

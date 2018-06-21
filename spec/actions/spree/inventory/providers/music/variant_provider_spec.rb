RSpec.describe Spree::Inventory::Providers::Music::VariantProvider, type: :action do
  subject(:variant) { described_class.call(item_json, options: options) }

  let(:options) { {} }
  let(:images) { [] }

  describe 'creation' do
    let(:sku) { '08-F-002387' }
    let(:item_json) do
      {
        sku: sku,
        quantity: '1',
        price: '9.61',
        condition: 'G+',
        format: 'vinyl',
        images: images,
        title: 'Goodwill Central Texas',
        artist: 'Jake Donaldson',
        description: 'Wow vinyl',
        genres: 'Hardcore',
        label: 'Epic',
        label_number: 'PK-32',
        speed: '12'
      }
    end

    context 'when new product' do
      subject(:product) { variant.product }

      context 'with images', vcr: true do
        let(:images) { Array.new(3, 'https://fakeimg.pl/1/') }

        it { expect(product.images.count).to eq(3) }
      end
    end
  end
end

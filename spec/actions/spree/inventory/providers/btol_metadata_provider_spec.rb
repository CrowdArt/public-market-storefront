require 'rails_helper'

RSpec.describe Spree::Inventory::Providers::BtolMetadataProvider, type: :action, vcr: true do
  subject(:properties) { metadata[:properties] }

  before { ENV['http_proxy'] = VCR.current_cassette.recording? ? 'http://storefront.simbi.com:3000' : '' }

  let(:metadata) { described_class.call(isbn) }

  context 'with known isbn' do
    let(:isbn) { '9780307341570' }

    it { expect(properties).to include(isbn: isbn) }
    it { expect(metadata[:title]).not_to be_empty }
    it { expect(metadata[:description]).not_to be_empty }
    it { expect(metadata[:dimensions]).not_to be_empty }
    it { expect(metadata[:price]).to be > 0 }
    it { expect(properties[:edition]).not_to be_nil }
    it { expect(properties[:language]).not_to be_nil }
    it { expect(properties[:pages]).not_to be_nil }
    it { expect(metadata[:taxons]).not_to be_empty }
  end

  context 'with unknown isbn' do
    let(:isbn) { 'UKNOWN_ISBN1' }

    it { expect(metadata).to be_nil }
  end

  context 'when title is flat' do
    let(:isbn) { '9781472579508' }

    it { expect(metadata[:title]).not_to be_empty }
  end

  context 'when flat annotations' do
    let(:isbn) { '9780691016177' }

    it { expect(metadata[:description]).not_to be_empty }
  end

  context 'when xml has bad symbols' do
    let(:isbn) { '9780688003296' }

    it { expect(metadata[:title]).not_to be_empty }
  end

  context 'when return multiple products' do
    let(:isbn) { '9780439376105' }

    it { expect(metadata[:title]).not_to be_empty }
  end

  context 'when pages field have colon' do
    let(:isbn) { '9780778804178' }

    it { expect(properties[:pages]).to eq('240 p.') }
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

    it 'create product and variant' do
      expect(variant).not_to be_nil
      expect(variant.sku).to eq(item_json[:sku])
      expect(variant.option_value('condition')).to eq(item_json[:condition])
      expect(variant.price).to be > 0
      expect(variant.total_on_hand).to eq(1)
      expect(variant.product.images.count).to eq(1)
      expect(variant.product.property(:edition)).to eq('1 Reprint')
      expect(variant.product.property(:language)).to eq('English')
      expect(variant.product.property(:pages)).to eq('349 p.')
      taxons = variant.product.taxons
      expect(taxons.count).to eq(1)
      expect(taxons.first.pretty_name).to eq('Categories -> Fiction -> Thrillers -> General')
    end
  end
end

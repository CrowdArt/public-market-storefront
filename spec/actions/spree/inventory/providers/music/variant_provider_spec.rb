require 'spec_helper'

RSpec.describe Spree::Inventory::Providers::Music::VariantProvider, type: :action do
  subject(:variant) { described_class.call(item_json, options: options) }

  let(:options) { {} }
  let(:images) { [] }

  describe 'validation' do
    let(:item_json) { { sku: 'sku' } }

    it do
      expect { variant }.to raise_error(Spree::ImportError).with_message(include(":artist=>[\"is missing\"]")) # rubocop:disable Style/StringLiterals
    end
  end

  describe 'creation' do
    let(:sku) { '08-F-002387' }
    let(:genre) { 'Hardcore' }
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
        genres: genre,
        label: 'Epic',
        label_number: 'PK-32',
        speed: '12'
      }
    end

    context 'when is invalid' do
      let(:item_json) do
        {
          sku: sku,
          quantity: '1',
          price: '9.61',
          condition: 'G+'
        }
      end

      it { expect { variant }.to raise_error(Spree::ImportError) }
    end

    context 'when new product' do
      subject(:product) { variant.product }

      it { expect(product).not_to be_nil }
      it { expect(product).to be_persisted }
      it { expect(product.available_on).not_to be_nil }
      it { expect(product.description).not_to be_nil }
      it do
        expect(product.properties.pluck(:presentation)).to eq(
          ['Artist', 'Record Format', 'Record Label', 'Catalog Number', 'RPM', 'Music genres']
        )
      end
      it { expect(product.option_types.count).to eq(1) }
      it { expect(product.variants.count).to eq(1) }
      it { expect(product.property(:artist)).not_to be_nil }
      it { expect(product.taxons.count).to eq(1) }
      it { expect(product.taxons.first.taxonomy.name).to eq('Music') }
      it { expect(product.taxons.first.name).to eq('Uncategorized') }

      it { expect(variant).not_to be_nil }
      it { expect(variant).not_to eq(product.master) }
      it { expect(variant.sku).to eq(item_json[:sku]) }
      it { expect(variant.option_values.first.name).to eq(item_json[:condition]) }
      it { expect(variant.option_value('vinyl_condition')).to eq("Used — Good 'Plus'") }
      it { expect(variant.price).to eq(item_json[:price]) }
      it { expect(variant.cost_price).to eq(item_json[:price]) }
      it { expect(variant.total_on_hand).to eq(1) }

      context 'with images', vcr: true, images: true do
        let(:images) { Array.new(3, 'https://fakeimg.pl/1/') }

        it { expect(product.images.count).to eq(3) }
      end

      context 'with taxonomy option' do
        let(:options) { { taxonomy: 'Music' } }

        it { expect(product.taxons.first.taxonomy.name).to eq('Music') }
      end

      describe 'taxonomy' do
        let(:taxonomy) { create(:taxonomy, name: 'Music') }

        context 'when taxon is absent' do
          it { expect(product.taxons.first.name).to eq('Uncategorized') }
        end

        context 'when taxon exists' do
          before { create(:taxon, name: genre, taxonomy: taxonomy) }

          it { expect(product.taxons.first.name).to eq(genre) }
        end
      end
    end

    context 'when variant already exists' do
      let(:sku) { '08-F-002387' }

      before do
        described_class.call(item_json)
        item_json[:quantity] = 2
        item_json[:price] = 10.50
      end

      it { expect { variant }.not_to change(Spree::Product, :count) }
      it { expect(variant.product.variants.count).to eq(1) }
      it { expect(variant.price).to eq(10.5) }
      it { expect(variant.cost_price).to eq(10.5) }
      it { expect(variant.total_on_hand).to eq(2) }
    end
  end
end

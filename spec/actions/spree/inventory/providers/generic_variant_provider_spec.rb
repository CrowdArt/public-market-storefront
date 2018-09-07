require 'spec_helper'

RSpec.describe Spree::Inventory::Providers::GenericVariantProvider, type: :action do
  subject(:variant) { described_class.call(item_json, options: options) }

  let(:options) { {} }
  let(:item_json) { {} }

  describe 'validation' do
    context 'when required fields are absent' do
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(include(':sku=>["is missing"]')) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(include(':product_id=>["is missing"]')) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(include(':quantity=>["must be filled"]')) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(include(':price=>["must be filled"]')) }
      it do
        expect {
          variant
        }.to raise_error(Spree::ImportError).with_message(include(':categories=>["is missing", "must be an array or must be a string"]'))
      end
    end

    context 'when fields have wrong types' do
      let(:item_json) do
        {
          sku: 5, product_id: 8773, categories: 5, quantity: '0', price: 'Zero',
          option_types: 5, images: 5, rewards_percentage: 'Free', weight: 'heavy',
          height: 'high', width: 'wide', depth: 'deep'
        }
      end

      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:sku/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:product_id/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:categories/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:images/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:option_types/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:rewards_percentage/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:weight/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:height/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:width/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:depth/)) }
    end
  end

  describe 'creation' do
    let(:item_json) do
      {
        sku: 'BL-001',
        product_id: product_id,
        categories: categories,
        quantity: 5,
        price: 3.99,
        title: 'Title',
        description: 'Description',
        notes: 'Notes',
        option_types: option_types,
        images: images,
        rewards_percentage: 1,
        keywords: keywords,
        **properties,
        **dimensions
      }
    end

    let(:product_id) { '789867898760' }
    let(:categories) { 'Beauty' }
    let(:option_types) { '' }
    let(:images) { [] }
    let(:product) { variant.product }
    let(:properties) { { color: 'Green' } }
    let(:dimensions) { {} }
    let(:keywords) { '' }

    it { expect(variant.sku).to eq(item_json[:sku]) }
    it { expect(variant.option_values.first.name).to eq('Default') }
    it { expect(variant.option_value('Default')).to eq('Default') }
    it { expect(variant.price).to eq(item_json[:price]) }
    it { expect(variant.cost_price).to eq(item_json[:price]) }
    it { expect(variant.total_on_hand).to eq(item_json[:quantity]) }
    it { expect(variant.notes).to eq(item_json[:notes]) }

    it { expect(product.name).to eq(item_json[:title]) }
    it { expect(product.available_on).not_to be_nil }
    it { expect(product.description).to eq(item_json[:description]) }
    it { expect(product.master.sku).not_to be_nil }
    it { expect(product.option_types.count).to eq(1) }
    it { expect(product.variants.count).to eq(1) }
    it { expect(product.properties.count).to eq(1) }
    it { expect(product.property('color')).to eq(item_json[:color]) }

    describe 'taxons' do
      it { expect(product.taxons.count).to eq(1) }
      it { expect(product.taxons.first.taxonomy.name).to eq('Beauty & Health') }
      it { expect(product.taxons.first.name).to eq('Beauty') }
    end

    context 'when option types are present' do
      let(:option_types) { 'color, size' }
      let(:properties) { { color: 'Red', size: 'XL' } }

      it { expect(product.option_types.count).to eq(2) }
    end

    describe 'images', images: true, vcr: true do
      context 'with given image meta' do
        let(:images) { ['https://fakeimg.pl/1/'] }

        it { expect(product.images.count).to eq(1) }
      end

      context 'with book provider meta' do
        let(:product_id) { '9780307341570' }
        let(:categories) { 'Books' }

        it { expect(product.images.count).to eq(1) }
      end
    end

    context 'with dimensions' do
      context 'with given dimensions' do
        let(:dimensions) do
          {
            weight: 10,
            height: 15.2,
            width: 1,
            depth: 2.52
          }
        end

        it 'saves dimensions' do
          expect(product.master.weight).to eq(10)
          expect(product.master.height).to eq(15.2)
          expect(product.master.width).to eq(1)
          expect(product.master.depth).to eq(2.52)
        end
      end

      context 'with book provider meta', vcr: true do
        let(:product_id) { '9780307341570' }
        let(:categories) { 'Books' }

        it 'saves dimensions' do
          expect(product.master.weight).to eq(0.59)
          expect(product.master.height).to eq(0.79)
          expect(product.master.width).to eq(5.12)
          expect(product.master.depth).to eq(8)
        end
      end
    end

    context 'with keywords' do
      let(:keywords) { 'keyword1 keyword2' }

      it 'saves tags' do
        expect(product.tag_list).to include('keyword1', 'keyword2')
      end
    end
  end
end

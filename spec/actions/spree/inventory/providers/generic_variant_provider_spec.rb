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
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(include(':categories=>["is missing", "must be an array or must be a string"]')) }
    end

    context 'when fields have wrong types' do
      let(:item_json) do
        {
          sku: 5, product_id: 8773, categories: 5, quantity: '0', price: 'Zero',
          option_types: 5, images: 5, rewards_percentage: 'Free'
        }
      end

      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:sku/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:product_id/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:categories/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:images/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:option_types/)) }
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
        rewards_percentage: 1
      }.merge(properties)
    end
    let(:product_id) { '789867898760' }
    let(:categories) { 'Beauty' }
    let(:option_types) { '' }
    let(:images) { '' }
    let(:product) { variant.product }
    let(:properties) { { color: 'Green' } }

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
    it { expect(product.taxons.count).to eq(1) }
    # it { expect(product.taxons.first.taxonomy.name).to eq('Beauty & Health') }
    # it { expect(product.taxons.first.name).to eq('Beauty') }

    context 'when option types are present' do
      let(:option_types) { 'color, size' }
      let(:properties) { { color: 'Red', size: 'XL' } }

      it { expect(product.option_types.count).to eq(2) }
    end
  end
end

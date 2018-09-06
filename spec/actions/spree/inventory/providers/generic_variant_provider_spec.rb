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
      it { expect { variant }.not_to raise_error(Spree::ImportError).with_message(match(/:quantity/)) }
      it { expect { variant }.not_to raise_error(Spree::ImportError).with_message(match(/:price/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:images/)) }
      it { expect { variant }.to raise_error(Spree::ImportError).with_message(match(/:option_types/)) }
    end
  end
end

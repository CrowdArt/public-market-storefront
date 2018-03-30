RSpec.describe Spree::Inventory::Providers::UpdateVariantSellerDecorator, type: :action, vcr: true do
  subject(:variant) { Spree::Inventory::Providers::DefaultVariantProvider.call(item_json) }

  let(:item_json) do
    {
      ean: '9780979728303',
      sku: '08-F-002387',
      condition: 'Acceptable',
      seller: 'Computer Store'
    }
  end

  describe '#update_variant_hook' do
    it 'sets seller to variant' do
      expect(variant.reload.seller).to eq(item_json[:seller])
    end
  end
end

RSpec.describe Spree::Product, type: :model do
  describe '#should_index?' do
    subject { product.should_index? }

    context 'when not in stock' do
      let(:product) { build_stubbed(:product) }

      it { is_expected.to be false }
    end

    context 'when in stock' do
      let(:product) { create(:product_in_stock) }

      it { is_expected.to be true }
    end

    describe 'triggers reindex on update', search: true do
      let!(:product) { create(:product) }

      before do
        product.master.stock_items.each { |si| si.update(backorderable: false) }
        Spree::Product.searchkick_index.refresh
      end

      it 'adds product to index on update' do
        expect {
          product.master.stock_items.first.adjust_count_on_hand(10)
          Spree::Product.searchkick_index.refresh
        }.to change { Spree::Product.search.count }.from(0).to(1)
      end
    end
  end
end

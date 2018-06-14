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

    context 'when has empty name' do
      let(:product) { create(:product, name: nil) }

      it { is_expected.to be false }
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

      context 'with empty name' do
        let!(:product) { create(:product_in_stock, name: nil) }

        it 'adds product to index on update' do
          expect {
            product.update(name: 'New correct name')
            Spree::Product.searchkick_index.refresh
          }.to change { Spree::Product.search.count }.from(0).to(1)
        end
      end
    end
  end

  describe '#estimated_ptrn' do
    subject { product.estimated_ptrn }

    let(:product) { build_stubbed(:product, price: price) }

    context 'when price < 1 $' do
      let(:price) { 0.19 }

      it { is_expected.to eq(0) }
    end

    context 'when price < 10 $' do
      let(:price) { 6.21 }

      it { is_expected.to eq(0) }
    end

    context 'when price > 10 $' do
      let(:price) { 60.21 }

      it { is_expected.to eq(6) }
    end
  end

  describe 'boost_factor and images relation' do
    subject { product.boost_factor }

    let(:product) { create :product, master: create(:master_variant, images: images) }

    context 'when has images' do
      let(:images) { create_list :image, 1 }

      it { is_expected.to eq(1) }
    end

    context 'when no images' do
      let(:images) { [] }

      it { is_expected.to eq(0) }
    end
  end

  describe '#name' do
    context 'with empty name' do
      subject(:product) { create(:product, name: nil) }

      it { is_expected.to be_valid }
      it { expect(product.name).to eq Spree::Product::MISSING_TITLE }
    end
  end
end

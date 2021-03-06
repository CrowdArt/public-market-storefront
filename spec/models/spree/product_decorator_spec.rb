RSpec.describe Spree::Product, type: :model do
  describe '#should_index?' do
    subject { product.should_index? }

    context 'when not in stock' do
      let(:product) { build_stubbed(:product) }

      it { is_expected.to be true }
    end

    context 'when in stock' do
      let(:product) { create(:product) }

      before do
        create(:variant, is_master: false, product: product)
      end

      it { is_expected.to be true }
    end

    context 'when has empty name' do
      let(:product) { create(:product, name: nil) }

      it { is_expected.to be false }
    end

    describe 'triggers reindex on update', search: true do
      let(:product) { create(:product) }
      let!(:variant) { create(:variant, is_master: false, product: product) }

      before do
        variant.stock_items.each do |si|
          si.update(backorderable: false)
          si.adjust_count_on_hand(-1)
        end
        Spree::Product.searchkick_index.refresh
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

      describe 'data reconcilation worker' do
        before do
          allow(PublicMarket::Workers::Slack::DataReconcilationWorker).to receive(:perform_async)

          product
        end

        it 'is called' do
          expect(PublicMarket::Workers::Slack::DataReconcilationWorker).to have_received(:perform_async).with(
            product_id: product.id,
            message_type: 'missing-title'
          )
        end
      end
    end
  end

  describe '#slug' do
    context 'when name is changed' do
      subject(:update_product) do
        product.update(name: 'New super name')
      end

      let!(:product) { create(:product, name: nil) }

      it 'resets slug' do
        expect {
          update_product
        }.to change(product.reload, :slug).to('new-super-name')
      end
    end
  end

  describe '#number' do
    subject(:product) { create(:product).number }

    it { is_expected.to include('PM') }
  end
end

RSpec.describe Spree::Variant, type: :model do
  describe 'best price changes' do
    subject { variant.product.reload.price }

    let!(:variant) { create(:variant, price: 10) }

    before { variant.stock_items.last.set_count_on_hand(10) }

    context 'when variant changes price' do
      before { variant.update(price: 1) }

      it { is_expected.to eq(1) }
    end

    context 'when adds new variant' do
      let!(:new_variant) { create(:variant, product: variant.product, price: 5) }

      before { new_variant.stock_items.last.set_count_on_hand(8) }

      it { is_expected.to eq(5) }

      context 'when sold out' do
        before { new_variant.stock_items.each(&:reduce_count_on_hand_to_zero) }

        it { is_expected.to eq(10) }
      end
    end
  end
end

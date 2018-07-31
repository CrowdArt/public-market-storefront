RSpec.describe Spree::Variant, type: :model do
  describe 'best price changes' do
    subject { variant.product.reload.price }

    let(:vendor) { create(:vendor) }
    let(:variant) { create(:variant, vendor: vendor, price: 10, count_on_hand: 10) }

    context 'when variant changes price' do
      before { variant.update(cost_price: 1, price: 1) }

      it { is_expected.to eq(1) }
    end

    context 'when adds new variant' do
      let!(:new_variant) { create(:variant, product: variant.product, price: 5, count_on_hand: 8) }

      it { is_expected.to eq(5) }

      context 'when sold out' do
        before { new_variant.stock_items.each(&:reduce_count_on_hand_to_zero) }

        it { is_expected.to eq(10) }
      end
    end

    context 'when vendor has markups' do
      let(:vendor) { create(:vendor, price_markups: create_list(:price_markup, 1, amount: 2)) }

      it { is_expected.to eq(12) }

      context 'when variant changes price' do
        before { variant.update(cost_price: 1, price: 1) }

        it { is_expected.to eq(3) }
      end

      context 'when adds new variant' do
        let(:new_vendor) { create(:vendor, price_markups: create_list(:price_markup, 1, amount: 1)) }
        let!(:new_variant) { create(:variant, vendor: new_vendor, product: variant.product, price: 5, count_on_hand: 8) }

        it { is_expected.to eq(6) }
        it { expect(variant.product.best_variant).to eq(new_variant) }

        context 'when sold out' do
          before { new_variant.stock_items.each(&:reduce_count_on_hand_to_zero) }

          it { is_expected.to eq(12) }
          it { expect(variant.product.best_variant).to eq(variant) }
        end
      end
    end
  end

  describe '#mapped_main_option_value' do
    subject { variant.mapped_main_option_value }

    let(:product) { build_stubbed(:product, taxons: taxons) }
    let(:taxons) { [] }
    let(:variant) { build_stubbed(:variant, product: product, option_values: option_values) }
    let(:option_values) { [] }

    context 'when books' do
      let(:taxons) { [create(:taxonomy, name: 'Books').root] }
      let(:option_values) { build_stubbed_list(:option_value, 1, name: 'New', presentation: 'New') }

      it { is_expected.to eq 'new' }

      context 'when used - new' do
        let(:option_values) { build_stubbed_list(:option_value, 1, name: 'Used - Like New', presentation: 'Used - Like New') }

        it { is_expected.to eq 'used' }
      end
    end

    context 'when music' do
      let(:taxons) { [create(:taxonomy, name: 'Music').root] }
      let(:option_values) { build_stubbed_list(:option_value, 1, name: 'New', presentation: 'New') }

      it { is_expected.to eq 'new' }

      context 'when used - ss' do
        let(:option_values) { build_stubbed_list(:option_value, 1, name: 'ss', presentation: 'Used - Like New') }

        it { is_expected.to eq 'like new' }
      end
    end
  end
end

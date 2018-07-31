RSpec.describe 'Invalidate product cache', type: :feature, search: true, caching: true do
  let!(:variant) { create(:book_variant) }

  before { Spree::Product.searchkick_index.refresh }

  describe 'product cards' do
    let(:rewards_amount) { (variant.price * rewards / 100.0).floor(3) }
    let(:rewards) { Spree::Config.rewards }

    subject do
      visit spree.products_path
      page
    end

    before { visit spree.products_path }

    it { is_expected.to have_text(variant.price) }
    it { is_expected.to have_text(rewards_amount) }

    context 'when variant reward is changed' do
      let(:rewards) { 1 }

      before { variant.update(rewards: rewards) }

      it { is_expected.to have_text(rewards_amount) }
    end

    context 'when vendor reward is changed' do
      let(:rewards) { 1 }

      before { variant.vendor.update(rewards: rewards) }

      it { is_expected.to have_text(rewards_amount) }
    end

    context 'when global reward is changed' do
      let(:rewards) { 1 }

      before { Spree::Config.rewards = rewards }

      it { is_expected.to have_text(rewards_amount) }
    end
  end
end
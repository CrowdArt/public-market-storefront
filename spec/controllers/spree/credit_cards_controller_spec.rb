RSpec.describe Spree::CreditCardsController, type: :controller do
  let(:user) { create(:user) }

  routes { Spree::Core::Engine.routes }

  before { allow(Spree::CreditCard).to receive(:find_by).and_return(card) }

  describe '#edit' do
    subject { get :edit, params: { id: card.slug } }

    let(:card) { build_stubbed(:credit_card, user: user) }

    context 'when not signed in' do
      it { is_expected.not_to be_success }
    end

    context 'when signed in' do
      before { sign_in(user) }

      it { is_expected.to be_success }

      context "when other's card" do
        let(:card) { build_stubbed(:credit_card) }

        it { is_expected.not_to be_success }
      end
    end
  end

  describe '#destroy' do
    subject(:delete_card) { delete :destroy, params: { id: card.slug } }

    let!(:card) { create(:credit_card, user: user) }

    context 'when not signed in' do
      it { is_expected.not_to be_success }
    end

    context 'when signed in' do
      before { sign_in(user) }

      it { is_expected.to redirect_to('/account/payment') }

      it 'deletes card' do
        expect {
          delete_card
        }.to change { user.credit_cards.count }.by(-1)
      end

      context "when other's card" do
        let!(:card) { create(:credit_card) } # rubocop:disable RSpec/LetSetup

        it { is_expected.not_to be_success }

        it 'does not delete card' do
          expect {
            delete_card
          }.not_to change { user.credit_cards.count }
        end
      end
    end
  end
end

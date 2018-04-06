RSpec.describe Spree::CreditCardsController, type: :controller do
  let(:user) { create(:user) }

  routes { Spree::Core::Engine.routes }

  describe '#edit' do
    subject { get :edit, params: { id: card.id } }

    let(:card) { create(:credit_card, user: user) }

    context 'when not signed in' do
      it { is_expected.not_to be_success }
    end

    context 'when signed in' do
      before { sign_in(user) }

      it { is_expected.to be_success }

      context "when other's card" do
        let(:card) { create(:credit_card) }

        it { is_expected.not_to be_success }
      end
    end
  end
end

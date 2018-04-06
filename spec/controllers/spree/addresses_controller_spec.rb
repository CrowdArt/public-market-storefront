RSpec.describe Spree::AddressesController, type: :controller do
  let(:user) { create(:user) }

  routes { Spree::Core::Engine.routes }

  describe '#edit' do
    subject { get :edit, params: { id: address.id } }

    let(:address) { create(:address, user: user) }

    context 'when not signed in' do
      it { is_expected.not_to be_success }
    end

    context 'when signed in' do
      before { sign_in(user) }

      it { is_expected.to be_success }

      context "when other's address" do
        let(:address) { create(:address) }

        it { is_expected.not_to be_success }
      end
    end
  end
end

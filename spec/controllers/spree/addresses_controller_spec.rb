RSpec.describe Spree::AddressesController, type: :controller do
  let(:user) { create(:user) }

  routes { Spree::Core::Engine.routes }

  before { allow(Spree::Address).to receive(:find).and_return(address) }

  describe '#edit' do
    subject(:get_address_edit) { get :edit, params: { id: address.id } }

    let(:address) { build_stubbed(:address, user: user) }

    context 'when not signed in' do
      it { is_expected.not_to be_successful }
    end

    context 'when signed in' do
      before { sign_in(user) }

      it { is_expected.to be_successful }

      it 'loads address' do
        expect {
          get_address_edit
        }.to change { assigns(:address) }.from(nil).to(address)
      end

      context "when other's address" do
        let(:address) { build_stubbed(:address) }

        it { is_expected.not_to be_successful }
      end
    end
  end
end

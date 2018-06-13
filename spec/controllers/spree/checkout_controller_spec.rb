RSpec.describe Spree::CheckoutController, type: :controller do
  let(:order) { create(:order_with_totals, email: nil, user: nil) }

  routes { Spree::Core::Engine.routes }

  before do
    allow(controller).to receive(:current_order) { order }
  end

  describe '#edit' do
    subject { get :edit, params: { state: 'address' } }

    before do
      allow(controller).to receive(:check_authorization)
    end

    context 'when authenticated as registered user' do
      before { allow(controller).to receive(:spree_current_user) { build_stubbed(:user) } }

      it { is_expected.to render_template :edit }
    end

    context 'when authenticated as guest' do
      it { is_expected.to redirect_to checkout_registration_path }

      context 'when order has filled email' do
        let(:order) { create(:order_with_totals, email: 'user@user.user', user: nil) }

        it { is_expected.to redirect_to checkout_registration_path }
      end
    end
  end
end

RSpec.describe Spree::UserConfirmationsController, type: :controller do
  let(:user) { create(:user, confirmed_at: nil) }

  routes { Spree::Core::Engine.routes }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:spree_user] # rubocop:disable RSpec/InstanceVariable
  end

  describe '#show' do
    it 'signs in after confirmation' do
      expect {
        get :show, params: { confirmation_token: user.confirmation_token }
      }.to change(warden, :user).from(nil).to(user)

      expect(response).to redirect_to(edit_account_path)
    end
  end

  describe '#create' do
    before { sign_in(user) }

    it 'shows notice message' do
      post :create

      expect(flash[:info]).to eq(I18n.t('devise.confirmations.send_instructions', email: user.email))
    end
  end
end

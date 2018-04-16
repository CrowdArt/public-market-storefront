RSpec.describe Spree::UserConfirmationsController, type: :controller do
  let(:user) { create(:user, confirmed_at: nil) }

  routes { Spree::Core::Engine.routes }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:spree_user] # rubocop:disable RSpec/InstanceVariable
    stub_current_store
  end

  describe '#show' do
    it 'signs in after confirmation' do
      expect {
        get :show, params: { confirmation_token: user.confirmation_token }
      }.to change(warden, :user).from(nil).to(user)

      expect(response).to redirect_to(root_path)
    end
  end
end
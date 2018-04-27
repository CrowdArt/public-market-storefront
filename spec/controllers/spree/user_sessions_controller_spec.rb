RSpec.describe Spree::UserSessionsController, type: :controller do
  let(:user) { create(:user, password: 'secretpassword') }

  routes { Spree::Core::Engine.routes }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:spree_user] # rubocop:disable RSpec/InstanceVariable
    stub_current_store
  end

  describe '#create' do
    subject(:post_create) do
      post :create, params: { spree_user: { email: user.email, password: 'secretpassword' }}
    end

    it 'signs in' do
      expect {
        post_create
      }.to change(warden, :user).from(nil).to(user)

      expect(response).to redirect_to(root_path)
    end

    it 'calls mixpanel tracking' do
      expect(controller).to receive(:set_mixpanel_tracking).with(user) # rubocop:disable RSpec/MessageSpies
      post_create
    end

    describe 'mixpanel script' do
      subject do
        post_create
        session[:mixpanel_actions]
      end

      it { is_expected.to include("mixpanel.identify('#{user.id}')") }

      it 'includes user set script' do
        is_expected.to include(
          <<~JS
            mixpanel.people.set({
              "$first_name": "#{user.first_name}",
              "$last_name": "#{user.last_name}",
              "$email": "#{user.email}",
              "$created": "#{user.created_at}"
            })
          JS
        )
      end

      it 'includes user signin event' do
        is_expected.to include(
          <<~JS
            mixpanel.track('signin', {
              "user_id": "#{user.id}",
              "email": "#{user.email}"
            })
          JS
        )
      end
    end
  end
end

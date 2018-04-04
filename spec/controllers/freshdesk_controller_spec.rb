RSpec.describe FreshdeskController, type: :controller do
  describe '#login' do
    subject(:response) { get :login }

    context 'when user is not signed in' do
      it { is_expected.to redirect_to('/user/spree_user/sign_in') }
    end

    context 'when user is signed in' do
      let(:user) { create :user }

      before { sign_in(user) }

      it { is_expected.to redirect_to(/\A#{Settings.freshdesk_url}/) }
      it { expect(response.location).to include(user.email.to_query(:email)) }
      it { expect(response.location).to include(user.full_name.to_query(:name)) }
    end
  end
end

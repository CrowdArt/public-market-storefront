RSpec.describe ErrorsController, type: :controller do
  before { allow(controller).to receive(:spree_current_user).and_return(nil) }

  describe '#not_found' do
    subject { get :not_found }

    it { is_expected.to have_http_status(:not_found) }
  end

  describe '#internal_server_error' do
    subject { get :internal_server_error }

    it { is_expected.to have_http_status(:internal_server_error) }
  end
end

RSpec.describe ErrorsController, type: :controller do
  describe '#not_found' do
    subject { get :not_found }

    it { is_expected.to have_http_status(:not_found) }
  end

  describe '#internal_server_error' do
    subject { get :internal_server_error }

    it { is_expected.to have_http_status(:internal_server_error) }
  end
end

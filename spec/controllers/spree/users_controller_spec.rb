RSpec.describe Spree::UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    create(:completed_order_with_totals, user: user)
  end

  routes { Spree::Core::Engine.routes }

  describe '#show' do
    it 'returns paginated orders' do
      get :show, params: { tab: :orders }

      expect(assigns(:orders).size).to eq 1
      expect(assigns(:orders).total_pages).to eq 1
      expect(assigns(:orders).total_count).to eq 1
    end

    it 'return no orders on next page' do
      get :show, params: { tab: :orders, page: 2 }

      expect(assigns(:orders).size).to eq 0
      expect(assigns(:orders).total_pages).to eq 1
      expect(assigns(:orders).total_count).to eq 1
    end
  end
end

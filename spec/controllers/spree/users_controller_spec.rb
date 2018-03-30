RSpec.describe Spree::UsersController, type: :controller do
  let(:user) { create(:pm_user) }

  before do
    create(:completed_order_with_totals, user: user)
    allow(controller).to receive(:spree_current_user) { user }
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

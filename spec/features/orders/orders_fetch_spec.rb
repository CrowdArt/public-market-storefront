require 'spec_helper'

RSpec.describe 'Orders fetch', type: :request do
  subject(:fetch) do
    get '/api/v1/orders/fetch', params: { token: token,
                                          from_timestamp: from.to_i }
    response
  end

  let(:json) { JSON.parse(fetch.body, symbolize_names: true) }
  let(:token) { '' }
  let(:from) { Time.current - 1.day }

  context 'when user is unauthorized' do
    it { is_expected.to have_http_status(:unauthorized) }
    it { expect(fetch.body).to match('You must specify an API key') }
  end

  context 'when user is authorized' do
    let(:user) { create :user, spree_api_key: 'secure', vendors: [vendor] }
    let(:vendor) { create :vendor }
    let(:token) { user.spree_api_key }

    context 'when no content' do
      it { is_expected.to have_http_status(:ok) }
      it { expect(json[:count]).to eq(0) }
    end

    context 'when have orders' do
      context 'when order is not ready' do
        before { create(:order_with_vendor_items, vendor: vendor) }

        it { expect(json).to include(count: 0) }
      end

      context 'when order is paid' do
        let!(:order) { create(:vendor_order_ready_to_ship, vendor: vendor) }

        it { expect(json).to include(orders: [hash_including(order_identifier: order.number)]) }
      end

      context 'when order is outdated' do
        let(:from) { Time.current + 1.day }

        it { expect(json[:count]).to eq(0) }
      end
    end
  end
end

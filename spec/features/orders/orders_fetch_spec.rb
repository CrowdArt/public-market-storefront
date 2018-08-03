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

      context 'when order is ready' do
        let(:order) { create(:completed_vendor_order, line_items_count: 2) }
        let(:unit) { order.inventory_units.first }
        let(:other_unit) { order.inventory_units.second }
        let(:vendor) { unit.variant.vendor }

        it { expect(json).to include(orders: [hash_including(order_number: order.number)]) }
        it { expect(json.dig(:orders, 0, :line_items, 0, :sku)).to match(unit.variant.sku) }
        it { expect(json.dig(:orders, 0, :line_items, 0, :name)).to match(unit.variant.name) }
        it { expect(json.dig(:orders, 0, :line_items, 0, :price)).to eq(unit.line_item.price.to_s) }
        it { expect(json.to_s).not_to match(other_unit.variant.sku) }
        it { expect(json.dig(:orders, 0, :id)).to match(order.hash_id) }
        it { expect(json.dig(:orders, 0, :total)).to eq(unit.line_item.price.to_s) }
        it { expect(json.dig(:orders, 0, :shipping_cost)).to eq('0.0') }
      end

      context 'when order is paid' do
        before { create(:vendor_order_ready_to_ship, vendor: vendor) }

        it { expect(json).to include(count: 0) }
      end

      context 'when order is outdated' do
        let(:from) { Time.current + 1.day }

        it { expect(json[:count]).to eq(0) }
      end
    end
  end
end

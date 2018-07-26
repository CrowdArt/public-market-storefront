require 'spec_helper'

RSpec.describe 'Update line items', type: :request do
  subject(:update) do
    post '/api/v1/orders/update', params: { token: token, updates: updates }
    response
  end

  let(:json) { JSON.parse(update.body, symbolize_names: true) }
  let(:token) { '' }
  let(:updates) { [] }

  context 'when user is unauthorized' do
    it { is_expected.to have_http_status(:unauthorized) }
    it { expect(update.body).to match('You must specify an API key') }
  end

  context 'when user is authorized' do
    let(:user) { create :user, spree_api_key: 'secure', vendors: [vendor] }
    let(:vendor) { order.vendors.first }
    let(:token) { user.spree_api_key }
    let(:order) { create(:vendor_order_ready_to_ship) }
    let(:unit) { order.inventory_units.first }

    context 'when unit is shipped' do
      let(:updates) { [{ order_number: order.number, item_number: unit.hash_id, action: :confirm }] }

      it { is_expected.to have_http_status(:ok) }
      it { expect(json).to include(result: { unit.hash_id.to_s.to_sym => 'shipped' }) }
      it { expect { update }.to change { unit.reload.state }.from('on_hand').to('shipped') }
    end

    context 'when unit is canceled' do
      let(:updates) { [{ order_number: order.number, item_number: unit.hash_id, action: :cancel }] }

      it { is_expected.to have_http_status(:ok) }
      it { expect(json).to include(result: { unit.hash_id.to_s.to_sym => 'canceled' }) }
      it { expect { update }.to change { unit.reload.state }.from('on_hand').to('canceled') }
    end

    context 'when order is shipped' do
      let(:updates) { [{ order_number: order.number, item_number: unit.hash_id, action: :confirm, tracking_number: '12313', shipped_at: shipped_at }] }
      let(:shipped_at) { 2.months.ago.to_i }

      it { is_expected.to have_http_status(:ok) }
      it { expect(json).to include(result: { unit.hash_id.to_s.to_sym => 'shipped' }) }
      it { expect { update }.to change { unit.reload.state }.from('on_hand').to('shipped') }
      it { expect { update }.to change { unit.shipment.reload.state }.from('ready').to('shipped') }
      it { expect { update }.to change { unit.shipment.reload.shipped_at.to_i }.from(0).to(shipped_at) }

      context 'when one item is canceled' do
        let(:order) { create(:vendor_order_ready_to_ship, line_items_quantity: 2) }
        let(:other_unit) { order.inventory_units.where.not(id: unit.id).first }

        before { other_unit.cancel! }

        it { is_expected.to have_http_status(:ok) }
      end
    end
  end
end

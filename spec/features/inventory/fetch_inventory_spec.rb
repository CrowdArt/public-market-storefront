require 'spec_helper'

RSpec.describe 'Inventory fetch', type: :request do
  subject(:fetch) do
    get '/api/v1/inventory/fetch', params: { token: token }
    response
  end

  let(:json) { JSON.parse(fetch.body, symbolize_names: true) }
  let(:token) { '' }

  context 'when user is unauthorized' do
    it { is_expected.to have_http_status(:unauthorized) }
    it { expect(fetch.body).to match('You must specify an API key') }
  end

  context 'when user is authorized' do
    let(:user) { create :user, spree_api_key: 'secure', vendors: [vendor] }
    let(:vendor) { create :vendor }
    let(:token) { user.spree_api_key }
    let!(:variant) { create :variant, vendor: vendor }

    it { expect(json.dig(:items, 0, :sku)).to eq(variant.sku) }
    it { expect(json.dig(:items, 0, :quantity)).to eq(1) }
    it { expect(json.dig(:items, 0, :updated_at)).to be_truthy }
    it { expect(json.dig(:total_count)).to eq(1) }
  end
end

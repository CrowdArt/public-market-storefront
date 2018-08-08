RSpec.describe GlobalReputation::Api, vcr: true do
  describe 'Rating#rate_shipment' do
    before { GlobalReputation::Api::Rating.rate_shipment(user, shipment, value) }

    let(:user) { create :user }
    let(:order) { create :order_with_vendor_items, user: user }
    let(:shipment) { order.shipments.first }
    let(:vendor) { shipment.vendor }
    let(:value) { 1 }
    let(:review) { 'review' }

    it { expect(shipment.rating_uid).to be_truthy }
    it { expect(user.reputation_uid).to be_truthy }
    it { expect(vendor.reload.reputation_uid).to be_truthy }

    context 'when vendor and user already has reputation uid' do
      subject(:rating) { GlobalReputation::Api::Rating.rate_shipment(user, other_shipment, value, review) }

      let(:other_order) { create :order_with_vendor_items, user: user, vendor: vendor }
      let(:other_shipment) { other_order.shipments.first }

      it { expect(vendor.reload.reputation_uid).to eq(rating.receiver) }
      it { expect(user.reputation_uid).to eq(rating.sender) }
      it { is_expected.to have_attributes(review: review) }
    end

    context 'when set rating modification' do
      subject(:rating) { GlobalReputation::Api::Rating.rate_shipment(user, shipment, new_value, new_review) }

      let(:new_value) { -1 }
      let(:new_review) { 'new review' }

      it { is_expected.to have_attributes(id: shipment.rating_uid, value: value, modification: new_value, review: new_review) }
      it { expect(rating.display_value).to eq(-1) }
    end
  end
end

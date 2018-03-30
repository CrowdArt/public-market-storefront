require 'rails_helper'

RSpec.describe GlobalReputation::Api, vcr: true do
  describe 'Rating#rate_order' do
    before do
      order.line_items.first.variant.update(vendor: vendor)
      GlobalReputation::Api::Rating.rate_order(user, order, value)
    end

    let(:user) { create :pm_user }
    let(:order) { create :order_with_line_items, user: user }
    let(:vendor) { create :vendor }
    let(:value) { 1 }

    it { expect(order.rating_uid).to be_truthy }
    it { expect(user.reputation_uid).to be_truthy }
    it { expect(vendor.reload.reputation_uid).to be_truthy }

    context 'when vendor and user already has reputation uid' do
      subject(:rating) { GlobalReputation::Api::Rating.rate_order(user, other_order, value) }

      let(:other_order) { create :order_with_line_items, user: user }

      before do
        other_order.line_items.first.variant.update(vendor: vendor)
      end

      it { expect(vendor.reload.reputation_uid).to eq(rating.receiver) }
      it { expect(user.reputation_uid).to eq(rating.sender) }
    end

    context 'when set rating modification' do
      subject(:rating) { GlobalReputation::Api::Rating.rate_order(user, order, new_value) }

      let(:new_value) { -1 }

      it { is_expected.to have_attributes(id: order.rating_uid, value: value, modification: new_value) }
      it { expect(rating.display_value).to eq(-1) }
      it { expect(rating.value_text).to eq('positive') }
      it { expect(rating.available_mod).to eq(-1) }
    end
  end
end

RSpec.describe Spree::Order, type: :model do
  describe 'ability' do
    subject(:ability) { Spree::Ability.new(order.user) }

    let(:user) { create :pm_user }
    let(:order) { create :order, user: user }

    it { expect(ability.can?(:rate, order)).to be_truthy } # rubocop:disable RSpec/PredicateMatcher
  end
end

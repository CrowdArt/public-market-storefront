require 'cancan/matchers'

RSpec.describe AbilityDecorator, type: :ability do
  subject(:ability) { Spree::Ability.new(user) }

  let(:user) { nil }

  context 'when is guest' do
    it { is_expected.not_to be_able_to(:rate, Spree::Order) }
    it { is_expected.not_to be_able_to(:create, Spree::Address) }
    it { is_expected.not_to be_able_to(:create, Spree::CreditCard) }
  end

  context 'when is registered user' do
    let(:user) { build_stubbed(:user) }

    describe 'rate' do
      let(:order) { build_stubbed(:order) }

      context 'with own order' do
        let(:order) { build_stubbed(:order, user: user) }

        it { is_expected.to be_able_to(:rate, order) }
      end

      context "with other's order" do
        let(:order) { build_stubbed(:order) }

        it { is_expected.not_to be_able_to(:rate, order) }
      end
    end

    shared_examples 'manage abilities' do |model|
      describe 'edit' do
        context 'with own' do
          let(:object) { build_stubbed(model, user: user) }

          it { is_expected.to be_able_to(:manage, object) }
        end

        context "with other's" do
          let(:object) { build_stubbed(model) }

          it { is_expected.not_to be_able_to(:manage, object) }
        end
      end
    end

    describe 'address' do
      it { is_expected.to be_able_to(:create, Spree::Address) }

      include_examples 'manage abilities', :address
    end

    describe 'credit card' do
      it { is_expected.to be_able_to(:create, Spree::CreditCard) }

      include_examples 'manage abilities', :credit_card
    end
  end

  context 'when is vendor' do
    let(:user) { build_stubbed(:user, vendors: build_stubbed_list(:vendor, 1)) }

    it { is_expected.not_to be_able_to(:create, Spree::ShippingMethod) }
  end
end

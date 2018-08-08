require 'contexts/credit_card'
require 'contexts/checkout'

RSpec.describe 'Credit card in checkout flow', type: :feature, js: true, vcr: true do
  let(:user) { create(:user) }
  let!(:stripe_card_payment_method) { create(:stripe_card_payment_method) }

  before do
    create(:address, user: user)
  end

  include_context 'with filled product cart'

  context 'when there is no pre-existing credit card' do
    before do
      click_button 'Proceed to Checkout'
    end

    include_context 'with filled stripe credit card in checkout'

    it 'completes checkout process' do
      expect(page).to have_text 'PAYMENT METHODS'
      expect(page).not_to have_text 'Use an existing card on file'

      click_button('Submit your order')

      expect(page).to have_text 'Your order has been processed successfully'
    end
  end

  context 'with existing credit card' do
    context 'with single credit card' do
      before do
        create(:credit_card, user: user, payment_method: stripe_card_payment_method)
        click_button 'Proceed to Checkout'
      end

      it 'completes checkout process' do
        expect(page).to have_text 'Use an existing card on file'

        click_button('Submit your order')

        expect(page).to have_text 'Your order has been processed successfully'
      end
    end

    context 'with multiple credit cards' do
      include Spree::PaymentHelper

      let!(:credit_card) { create(:credit_card, default: true, name: 'First', user: user, payment_method: stripe_card_payment_method) }
      let!(:different_credit_card) { create(:credit_card, name: 'Second', user: user, payment_method: stripe_card_payment_method) }

      before do
        click_button 'Proceed to Checkout'
      end

      it 'chooses different card' do
        click_button(payment_method_dropdown_item(credit_card))

        page.execute_script("$(\"label[for='order_existing_card_#{different_credit_card.id}']\").trigger('click')")

        click_button('Submit your order')

        expect(page).to have_text 'Your order has been processed successfully'
        expect(Spree::Order.last.payments.first.source).to eq different_credit_card
        expect(Spree::Order.last.billing_address.address1).to eq different_credit_card.address.address1
      end
    end
  end
end

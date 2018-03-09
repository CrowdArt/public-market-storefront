require 'rails_helper'

RSpec.describe 'credit card actions', type: :feature, js: true do
  let(:user) { create(:bookstore_user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')
    create(:credit_card_payment_method, name: 'Credit card method')
    create(:credit_card_payment_method, name: 'Credit card method 2')

    login_as(user, scope: :spree_user)
  end

  context 'without billing address' do
    before do
      visit '/account/payment'

      click_link 'Add new payment method'

      fill_in 'name_on_card_1', with: 'Fake first Fake last'

      choose 'Credit card method 2'

      fill_in 'name_on_card_2', with: 'First name Last name'
      fill_in 'card_expiry', with: '10/18'
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '911'

      click_button 'Save and Continue'
    end

    it 'adds new card' do
      expect(user.credit_cards.count).to eq(1)
      expect(page).to have_text('First name Last name')
    end

    it 'deletes card' do
      click_link 'Delete'
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_text('First name Last name')
    end
  end

  context 'with billing address' do
    before do
      user.billing_address = create(:address, firstname: 'First name', lastname: 'Last name')
      user.save

      visit '/account/payment/edit'

      fill_in 'card_expiry', with: '10/18'
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '911'

      click_button 'Save and Continue'
    end

    it 'adds new card' do
      expect(user.credit_cards.count).to eq(1)
      expect(page).to have_text("#{user.billing_address.firstname} #{user.billing_address.lastname}")
    end
  end
end
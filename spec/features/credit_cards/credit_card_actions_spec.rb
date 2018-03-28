require 'rails_helper'

RSpec.describe 'credit card actions', type: :feature, js: true do
  let(:user) { create(:bookstore_user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')
  end

  describe 'add/delete card' do
    before do
      create(:credit_card_payment_method, name: 'Credit card method')

      login_as(user, scope: :spree_user)
    end

    context 'without shipping address' do
      before do
        visit '/account/payment'

        click_link 'Add new payment method'

        fill_in 'name_on_card_1', with: 'First name Last name'
        fill_in 'card_expiry', with: '10/18'
        fill_in 'card_number', with: '4242424242424242'
        fill_in 'card_code', with: '911'
      end

      context 'with valid address' do
        before do
          fill_in 'payment_source_1_address_attributes_firstname', with: 'First name'
          fill_in 'payment_source_1_address_attributes_lastname', with: 'Last name'
          fill_in 'payment_source_1_address_attributes_address1', with: 'Alaska'
          fill_in 'payment_source_1_address_attributes_city', with: 'Wellington'
          select 'Alabama', from: 'payment_source_1_address_attributes_state_id'
          fill_in 'payment_source_1_address_attributes_zipcode', with: '94001'

          click_button 'Save and Continue'
        end

        it 'adds new card' do
          expect(page).to have_text('First name Last name'.upcase)
          expect(user.credit_cards.count).to eq(1)
        end

        it 'deletes card' do
          click_link 'Remove'
          page.driver.browser.switch_to.alert.accept
          expect(page).not_to have_text('First name Last name'.upcase)
        end
      end

      context 'with invalid address' do
        before do
          fill_in 'payment_source_1_address_attributes_firstname', with: 'First name'
          fill_in 'payment_source_1_address_attributes_lastname', with: 'Last name'
          fill_in 'payment_source_1_address_attributes_address1', with: 'Alaska'
          fill_in 'payment_source_1_address_attributes_city', with: 'Wellington'
          select 'Alabama', from: 'payment_source_1_address_attributes_state_id'
          fill_in 'payment_source_1_address_attributes_zipcode', with: '94001'

          click_button 'Save and Continue'
        end

        it 'does not add new card' do
          expect(page).to have_text('First name Last name'.upcase)
          expect(user.credit_cards.count).to eq(1)
        end
      end
    end

    context 'with shipping address' do
      before do
        user.shipping_address = create(:address, firstname: 'First name', lastname: 'Last name')
        user.save

        visit '/account/payment/edit'

        fill_in 'card_expiry', with: '10/18'
        fill_in 'card_number', with: '4242424242424242'
        fill_in 'card_code', with: '911'

        click_button 'Save and Continue'
      end

      it 'adds new card' do
        expect(page).to have_text("#{user.shipping_address.firstname} #{user.shipping_address.lastname}".upcase)
        expect(user.credit_cards.count).to eq(1)
      end
    end
  end

  describe 'saves funding type' do
    let(:user) { create(:bookstore_user, shipping_address: create(:address, firstname: 'First name', lastname: 'Last name')) }

    before do
      create(:stripe_card_payment_method, name: 'Credit card method')

      login_as(user, scope: :spree_user)

      visit '/account/payment/edit'

      fill_in 'card_expiry', with: '10/18'
      fill_in 'card_code', with: '911'
    end

    context 'when credit card' do
      before do
        fill_in 'card_number', with: '4242424242424242' # stripe test credit card
        click_button 'Save and Continue'
      end

      it 'adds new credit card' do
        expect(page).to have_text("#{user.shipping_address.firstname} #{user.shipping_address.lastname}".upcase)
        expect(user.credit_cards.last.funding_credit?).to be true
      end
    end

    context 'when debit card' do
      before do
        fill_in 'card_number', with: '4000056655665556' # stripe test debit card
        page.execute_script("$('.cardNumber').trigger('change')")
        click_button 'Save and Continue'
      end

      it 'adds new credit card' do
        expect(page).to have_text("#{user.shipping_address.firstname} #{user.shipping_address.lastname}".upcase)
        expect(user.credit_cards.last.funding_debit?).to be true
      end
    end
  end
end

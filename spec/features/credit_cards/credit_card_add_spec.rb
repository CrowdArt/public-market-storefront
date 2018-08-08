require 'contexts/credit_card'

RSpec.describe 'Credit card add', type: :feature, js: true, vcr: true do
  let(:user) { create(:user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')
    create(:stripe_card_payment_method, name: 'Credit card method')

    login_as(user, scope: :spree_user)
  end

  context 'without shipping address' do
    before do
      visit '/account/payment'

      click_link 'Add new payment method'
    end

    include_context 'with filled stripe card in edit form'

    context 'with valid address' do
      before do
        fill_in 'credit_card_address_attributes_firstname', with: 'First name'
        fill_in 'credit_card_address_attributes_lastname', with: 'Last name'
        fill_in 'credit_card_address_attributes_address1', with: 'Alaska'
        fill_in 'credit_card_address_attributes_city', with: 'Wellington'
        fill_in 'credit_card_address_attributes_zipcode', with: '94001'

        click_button 'Save Payment Method'

        wait_for_stripe # Wait for Stripe API to return + form to submit
      end

      it 'adds new card' do
        expect(page).to have_text('ADD NEW PAYMENT METHOD')
        expect(user.credit_cards.count).to eq(1)
      end
    end

    context 'with invalid address' do
      before do
        fill_in 'credit_card_address_attributes_firstname', with: 'First name'
        fill_in 'credit_card_address_attributes_city', with: 'Wellington'
        fill_in 'credit_card_address_attributes_zipcode', with: '94001'

        click_button 'Save Payment Method'
      end

      it 'does not add new card' do
        expect(user.credit_cards.count).to eq(0)
      end
    end
  end

  context 'with existing shipping address' do
    before do
      create(:address, user: user, firstname: 'First name', lastname: 'Last name')

      visit '/account/payment/edit'
    end

    include_context 'with filled stripe card in edit form'

    it 'adds new card' do
      wait_for_stripe # Wait for Stripe API to return + form to submit

      click_button 'Save Payment Method'

      expect(page).to have_text('ADD NEW PAYMENT METHOD')
      expect(user.credit_cards.count).to eq(1)
      expect(user.addresses.count).to eq 1
    end
  end
end

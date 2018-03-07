require 'rails_helper'

RSpec.describe 'billing address update', type: :feature, js: true do
  let(:user) { create(:bookstore_user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')

    login_as(user, scope: :spree_user)

    visit spree.account_path(tab: :payment)

    fill_in 'user_bill_address_attributes_firstname', with: 'First name'
    fill_in 'user_bill_address_attributes_lastname', with: 'Last name'
    fill_in 'user_bill_address_attributes_address1', with: 'Alaska'
    fill_in 'user_bill_address_attributes_city', with: 'Wellington'
    select 'Alabama', from: 'user_bill_address_attributes_state_id'
    fill_in 'user_bill_address_attributes_zipcode', with: '94001'
    fill_in 'user_bill_address_attributes_phone', with: '+19997774088'
  end

  it 'updates billing address' do
    expect {
      click_button 'Save my address'
    }.to change { user.reload.billing_address }.from(nil)
  end

  context 'when use as shipping address is checked' do
    before { check('Use as my shipping address') }

    it 'updates shipping address' do
      expect {
        expect {
          click_button 'Save my address'
        }.to change { user.reload.billing_address }.from(nil)
      }.to change { user.reload.shipping_address }.from(nil)
    end
  end
end

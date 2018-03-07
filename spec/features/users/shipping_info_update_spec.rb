require 'rails_helper'

RSpec.describe 'shipping info update', type: :feature, js: true do
  let(:user) { create(:bookstore_user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')

    login_as(user, scope: :spree_user)

    visit spree.account_path(tab: :shipping)

    fill_in 'user_ship_address_attributes_firstname', with: 'First name'
    fill_in 'user_ship_address_attributes_lastname', with: 'Last name'
    fill_in 'user_ship_address_attributes_address1', with: 'Alaska'
    fill_in 'user_ship_address_attributes_city', with: 'Wellington'
    select 'Alabama', from: 'user_ship_address_attributes_state_id'
    fill_in 'user_ship_address_attributes_zipcode', with: '94001'
    fill_in 'user_ship_address_attributes_phone', with: '+19997774088'
  end

  it 'updates shipping address' do
    expect {
      click_button 'Save my address'
    }.to change { user.reload.ship_address }.from(nil)
  end
end

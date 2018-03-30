RSpec.describe 'shipping info update', type: :feature, js: true do
  let(:user) { create(:pm_user) }

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

  context 'with wrong fields' do
    before { fill_in 'user_ship_address_attributes_zipcode', with: '11194001' }

    it 'does not update address' do
      expect {
        click_button 'Save my address'
      }.not_to change { user.reload.ship_address }.from(nil)
    end
  end
end

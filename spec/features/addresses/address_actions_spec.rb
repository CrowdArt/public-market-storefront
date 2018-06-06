RSpec.describe 'address actions', type: :feature do
  let(:user) { create(:user) }

  before do
    create(:state, name: 'Alabama', abbr: 'AL')
    login_as(user, scope: :spree_user)
  end

  describe 'new address' do
    before do
      visit 'account/shipping/edit'

      fill_in 'address_firstname', with: 'First name'
      fill_in 'address_lastname', with: 'Last name'
      fill_in 'address_address1', with: 'Alaska'
      fill_in 'address_city', with: 'Wellington'
      select 'Alabama', from: 'address_state_id'
      fill_in 'address_zipcode', with: '94001'
    end

    it 'updates shipping address' do
      click_button 'Save my address'
      expect(page).to have_text('Wellington')
      expect(user.addresses.count).to eq 1
    end

    context 'with wrong fields' do
      before { fill_in 'address_zipcode', with: '11194001' }

      it 'does not update address' do
        expect {
          click_button 'Save my address'
        }.not_to change(user, :addresses)
      end
    end

    context 'with phone number', js: true do
      before do
        fill_in 'address_phone_without_code', with: '+19997774088'
        click_button 'Save my address'
      end

      it 'updates shipping address with phone number' do
        expect(page).to have_text('Wellington')
        expect(user.addresses.count).to eq 1
        expect(user.addresses.last.phone).to eq '+19997774088'
      end
    end
  end

  describe 'update address' do
    let(:address) { user.addresses.first }

    before do
      user.addresses << create(:address)
      visit spree.edit_address_path(address)
    end

    it 'updates shipping address' do
      fill_in 'address_firstname', with: 'First name 1'

      click_button 'Save my address'
      expect(page).to have_text('First name 1')
    end

    context 'with wrong fields' do
      before { fill_in 'address_zipcode', with: '11194001' }

      it 'does not update address' do
        click_button 'Save my address'
        expect(page).not_to have_text('First name 1')
      end
    end
  end

  describe 'delete address', js: true do
    before do
      user.addresses << create(:address)
      visit spree.user_addresses_path
    end

    it 'removes shipping address' do
      click_link 'Remove'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text(I18n.t('addresses.no_addresses'))
    end
  end
end

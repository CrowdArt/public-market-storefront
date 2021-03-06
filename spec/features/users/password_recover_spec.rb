RSpec.describe 'password recover', type: :feature do
  before do
    visit 'password/recover'
  end

  context 'with not existing email' do
    before do
      fill_in 'Email', with: 'notexistingemail@spree.com'
      click_button Spree.t('reset_password')
    end

    it 'shows notification' do
      expect(page).to have_content('not found')
    end
  end

  context 'with existing email' do
    let(:user) { create(:user, email: 'user@spree.com', password: 'password') }

    before do
      fill_in 'Email', with: user.email
      click_button Spree.t('reset_password')
    end

    it 'shows notification' do
      expect(page).to have_content(I18n.t('devise.user_passwords.spree_user.send_instructions', email: user.email))
    end
  end
end

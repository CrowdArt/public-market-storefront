RSpec.describe 'Sign In', type: :feature do
  let(:user) { create(:user, password: 'password') }
  let(:email) { user.email }
  let(:password) { 'password' }

  before do
    stub_current_store

    visit spree.login_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_button 'Log In'
  end

  context 'with invalid credentials' do
    let(:password) { '' }

    it 'does not sign in user' do
      expect(page).to have_content(I18n.t('devise.failure.invalid'), count: 2)
    end
  end
end

RSpec.describe 'Sign In', type: :feature do
  let(:user) { create(:user, login: 'superlogin', password: 'password') }
  let(:username) { user.email }
  let(:password) { 'password' }

  before do
    visit spree.login_path

    fill_in 'Email/Login', with: username
    fill_in 'Password', with: password

    click_button 'Log In'
  end

  context 'with invalid credentials' do
    context 'when password' do
      let(:password) { '' }

      it 'does not sign in user' do
        expect(page).to have_content(I18n.t('devise.failure.invalid'), count: 2)
      end
    end

    context 'when username' do
      let(:username) { '' }

      it 'does not sign in user' do
        expect(page).to have_content(I18n.t('devise.failure.invalid'), count: 2)
      end
    end
  end

  context 'with email' do
    let(:email) { user.email }

    it 'signs in user' do
      expect(page).to have_content('Logged in successfully')
    end
  end

  context 'with login' do
    let(:email) { user.login }

    it 'signs in user' do
      expect(page).to have_content('Logged in successfully')
    end
  end
end

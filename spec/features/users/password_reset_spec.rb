RSpec.describe 'Password reset', type: :feature do
  subject { page }

  let(:user) { create(:user, password: 'secretpassword') }
  let!(:old_password) { user.encrypted_password }

  before do
    login_as(user, scope: :spree_user)

    visit spree.edit_account_path
  end

  shared_examples 'resets password' do
    it do
      click_link 'Reset Password'
      expect(page).to have_text I18n.t('devise.user_passwords.spree_user.send_instructions')

      token = ActionMailer::Base.deliveries.last.html_part.body.match(/reset_password_token=\w*/)[0]
      visit '/user/spree_user/password/edit?' + token

      fill_in 'spree_user_password', with: 'password'
      fill_in 'spree_user_password_confirmation', with: 'password'
      click_button 'Save'

      expect(page).to have_text 'Your password has been changed successfully.'
      expect(user.reload.encrypted_password).not_to eq old_password
    end
  end

  context 'when signed in' do
    include_examples 'resets password'
  end

  context 'when signed out' do
    before do
      logout(user)
    end

    include_examples 'resets password'
  end
end

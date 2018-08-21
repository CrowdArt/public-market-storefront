RSpec.xdescribe 'Password reset', type: :feature do
  subject { page }

  let(:user) { create(:user, password: 'secretpassword') }
  let!(:old_password) { user.encrypted_password }

  let(:token) { ActionMailer::Base.deliveries.last.html_part.body.match(/reset_password_token=[^"]+/)[0] }

  shared_examples 'resets password' do
    it do
      visit '/user/spree_user/password/edit?' + token

      fill_in 'spree_user_password', with: 'password'
      fill_in 'spree_user_password_confirmation', with: 'password'
      click_button 'Save'

      expect(page).to have_text 'Your password has been changed successfully.'
      expect(user.reload.encrypted_password).not_to eq old_password
    end
  end

  context 'when signed in' do
    before do
      logout(:spree_user)
      login_as(user, scope: :spree_user)

      visit spree.edit_account_path

      click_link 'Reset Password'
      expect(page).to have_text I18n.t('devise.user_passwords.spree_user.send_instructions')
    end

    include_examples 'resets password'
  end

  context 'when signed out' do
    before do
      logout(:spree_user)
      visit '/password/recover'

      fill_in 'spree_user_email', with: user.email
      click_button Spree.t('reset_password')
    end

    include_examples 'resets password'
  end
end

require 'rails_helper'

RSpec.describe 'password recover', type: :feature, js: true do
  let(:user) { create(:user, email: 'user@spree.com', password: 'password') }

  before do
    stub_current_store
    visit 'password/recover'
  end

  context 'with not existing email' do
    before do
      fill_in 'Email', with: 'notexistingemail@spree.com'
      click_button 'Reset my password'
    end

    it 'sends reset code' do
      expect(page).to have_content('Email not found')
    end
  end

  context 'with existing email' do
    before do
      fill_in 'Email', with: user.email
      click_button 'Reset my password'
    end

    it 'sends reset code' do
      expect(page).to have_content(I18n.t('devise.user_passwords.spree_user.send_instructions'))
    end
  end
end

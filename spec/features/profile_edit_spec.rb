require 'rails_helper'

RSpec.describe 'profile edit', type: :feature, js: true do
  let(:user) { create(:bookstore_user, email: 'user@spree.com', password: 'secret') }
  let!(:old_password) { user.encrypted_password }

  before do
    login_as(user, scope: :spree_user)

    visit spree.edit_account_path
  end

  it 'updates password' do
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Update password'

    expect(page).to have_text 'Account updated'
    expect(user.reload.encrypted_password).not_to eq old_password
  end

  it 'updates basic info' do
    fill_in 'user_email', with: 'newemail@spree.com'
    fill_in 'user_first_name', with: 'User first name'
    fill_in 'user_last_name', with: 'User last name'
    click_button 'Update profile'

    expect(page).to have_text 'Account updated'
    expect(page).to have_content 'newemail@spree.com'
  end
end

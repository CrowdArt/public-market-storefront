require 'rails_helper'

RSpec.describe 'profile edit', type: :feature, search: true do
  let(:user) { create(:user, email: 'user@spree.com', password: 'secret') }
  let!(:old_password) { user.encrypted_password }

  before do
    visit spree.root_path
    click_link 'Login'

    fill_in 'spree_user[email]', with: user.email
    fill_in 'spree_user[password]', with: 'secret'
    click_button 'Login'

    visit spree.edit_account_path
  end

  it 'updates password', js: true do
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Update'

    expect(page).to have_text 'Account updated'
    expect(user.reload.encrypted_password).not_to eq old_password
  end
end

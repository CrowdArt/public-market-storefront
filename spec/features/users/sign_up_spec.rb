require 'rails_helper'

RSpec.describe 'Sign Up', type: :feature do
  before do
    visit spree.signup_path

    fill_in 'Email', with: email
    fill_in 'First Name', with: first_name
    fill_in 'Last Name', with: last_name
    fill_in 'Password', with: password
    fill_in 'Password Confirmation', with: password_confirmation

    click_button 'Create'
  end

  let(:email) { 'email@spree.com' }
  let(:first_name) { 'First name' }
  let(:last_name) { 'Last name' }
  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }

  context 'with valid data' do
    it 'creates a new user' do
      expect(page).to have_text 'You have signed up successfully.'
      expect(Spree::User.count).to eq(1)
    end
  end

  context 'with empty first/last name' do
    let(:first_name) { '' }

    it 'does not create a new user' do
      expect(page).to have_content("First name can't be blank")
      expect(Spree::User.count).to eq(0)
    end
  end

  context 'with not matching password confirmation' do
    let(:password_confirmation) { '' }

    it 'does not create a new user' do
      expect(page).to have_content("Password Confirmation doesn't match Password")
      expect(Spree::User.count).to eq(0)
    end
  end
end

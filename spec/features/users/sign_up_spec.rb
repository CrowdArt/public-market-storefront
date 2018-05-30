RSpec.describe 'Sign Up', type: :feature do
  before do
    visit spree.signup_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Confirm Password', with: password_confirmation

    click_button 'Sign Up'
  end

  let(:email) { 'email@spree.com' }
  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }

  context 'with valid data' do
    it 'creates a new user' do
      expect(page).to have_text 'Welcome! You have signed up successfully.'
      expect(Spree::User.count).to eq(1)
    end
  end

  context 'with not matching password confirmation' do
    let(:password_confirmation) { '' }

    it 'does not create a new user' do
      expect(page).to have_content("Sorry, your passwords didn't match. Please try again.")
      expect(Spree::User.count).to eq(0)
    end
  end
end

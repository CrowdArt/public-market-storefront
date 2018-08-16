RSpec.describe 'profile edit', type: :feature do
  subject { page }

  let(:user) { create(:user, email: 'user@spree.com', password: 'secretpassword') }
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

  describe 'basic info' do
    before do
      fill_in 'user_first_name', with: 'User first name'
      fill_in 'user_last_name', with: 'User last name'
    end

    context 'with correct info' do
      before { click_button 'Save' }

      it { is_expected.to have_text 'Account updated' }
      it { is_expected.to have_text 'User first name' }
    end

    context 'with incorrect info' do
      before do
        fill_in 'user_first_name', with: ''
        click_button 'Save'
      end

      it { is_expected.to have_text "First name can't be blank" }
    end
  end
end

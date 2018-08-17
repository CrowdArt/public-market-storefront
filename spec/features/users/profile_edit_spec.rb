RSpec.describe 'profile edit', type: :feature do
  subject { page }

  let(:user) { create(:user, email: 'user@spree.com', password: 'secretpassword') }

  before do
    login_as(user, scope: :spree_user)

    visit spree.edit_account_path
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

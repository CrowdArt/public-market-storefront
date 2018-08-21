RSpec.describe 'update email address', type: :feature do
  subject { page }

  let(:user) { create(:user, email: 'user@spree.com') }

  before do
    login_as(user, scope: :spree_user)

    visit spree.edit_account_path

    fill_in 'user_email', with: 'newemail@spree.com'

    click_button 'Save'
  end

  it { is_expected.to have_text 'An email with a confirmation link has been sent to your email address.' }

  it 'does not update original email untill confirmed' do
    expect(user.reload.email).to eq('user@spree.com')
    expect(user.unconfirmed_email).to eq('newemail@spree.com')
  end

  describe 'visit confirmation link' do
    before do
      visit spree.spree_user_confirmation_url(confirmation_token: user.reload.confirmation_token)
    end

    it 'updates original email' do
      expect(user.reload.email).to eq('newemail@spree.com')
      expect(user.unconfirmed_email).to be_nil
    end

    it { is_expected.to have_text "You've successfully updated your email address." }
  end
end

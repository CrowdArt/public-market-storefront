RSpec.describe 'update email address', type: :feature do
  subject { page }

  let(:user) { create(:user, email: 'user@spree.com') }

  before do
    login_as(user, scope: :spree_user)

    visit spree.edit_account_path

    fill_in 'user_email', with: 'newemail@spree.com'
  end

  it 'updates original email' do
    click_button 'Save'

    expect(user.reload.email).to eq('newemail@spree.com')
    expect(user.confirmed?).to be false
  end

  context 'when confirmed', js: true do
    let(:user) { create(:user, confirmed_at: Time.current, email: 'user@spree.com') }

    it 'updates original email' do
      click_button 'Save'
      click_button 'Yes, Change Email'

      is_expected.to have_text Spree.t(:account_email_updated)
      expect(user.reload.email).to eq('newemail@spree.com')
      expect(user.confirmed?).to be false
    end
  end

  describe 'visit confirmation link' do
    before do
      click_button 'Save'

      visit spree.spree_user_confirmation_url(confirmation_token: user.reload.confirmation_token)
    end

    it 'updates original email' do
      expect(user.reload.email).to eq('newemail@spree.com')
      expect(user.confirmed?).to be true
    end

    it { is_expected.to have_text I18n.t('devise.confirmations.confirmed') }
  end
end

RSpec.describe 'Credit card deletion', type: :feature, js: true, vcr: true do
  let(:user) { create(:user) }

  before do
    create(:credit_card, last_digits: '4242', user: user, address: create(:address, address1: 'Initial street address'))
    login_as(user, scope: :spree_user)
    visit spree.user_payment_methods_path
  end

  it 'deletes card' do
    click_link 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_text('Card was deleted')
    expect(user.credit_cards.count).to eq 0
  end
end

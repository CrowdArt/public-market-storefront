require 'contexts/checkout'

RSpec.describe 'checkout', type: :feature, js: true do
  let(:user) { nil }

  include_context 'with filled product cart'

  before do
    create(:stripe_card_payment_method)
    click_button 'Proceed to Checkout'
  end

  context 'when user is unathorized' do
    it { expect(page).to have_text 'REGISTER' }
  end

  context 'when user is authorized' do
    let(:user) { create(:user) }

    it { expect(page).to have_button 'Submit your order' }
  end
end

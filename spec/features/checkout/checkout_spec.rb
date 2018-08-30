require 'contexts/address'
require 'contexts/credit_card'
require 'contexts/checkout'

RSpec.describe 'Checkout', type: :feature, js: true do
  let(:user) { nil }

  context 'when user is unathorized', vcr: true do
    include_context 'with filled product cart', stripe_account: false

    before do
      click_button 'Proceed to Checkout'
    end

    it { expect(page).to have_text 'REGISTER' }
  end

  # rubocop:disable RSpec/LetSetup
  context 'when user is authorized', vcr: true do
    let(:user) { create(:user) }
    let!(:credit_card) { create(:credit_card, user: user, payment_method: create(:stripe_card_payment_method)) }
    let!(:address) { create(:address, user: user) }

    include_context 'with filled product cart'

    before do
      click_button 'Proceed to Checkout'
    end

    it { expect(page).to have_button 'Submit your order' }

    context 'with unconfirmed email', enqueue: true do
      let!(:user) { create(:user, confirmed_at: nil) }

      before do
        ActionMailer::Base.deliveries.clear # clear after user created
        click_button 'Submit your order'
      end

      it 'sends confirmation email and shows alert' do
        expect(page).to have_text ActionView::Base.full_sanitizer.sanitize(I18n.t('account.confirm_alert', email: user.email))

        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries.first.subject).to include I18n.t('emails.confirmation.subject')
      end
    end
  end
  # rubocop:enable RSpec/LetSetup
end

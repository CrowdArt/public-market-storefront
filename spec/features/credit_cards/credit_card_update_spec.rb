require 'contexts/credit_card'

RSpec.describe 'Credit card update', type: :feature, js: true, vcr: true do
  let(:user) { create(:user) }

  let(:card) do
    create(:credit_card, last_digits: '4242', user: user, payment_method: create(:stripe_card_payment_method))
  end

  before do
    login_as(user, scope: :spree_user)
    visit spree.edit_credit_card_path(card)

    fill_in 'credit_card_address_attributes_address1', with: 'Alaska New Street'

    click_button('Edit')
  end

  include_context 'with filled stripe card in edit form'

  it 'updates existing card' do
    click_button('Save and Continue')

    wait_for_stripe # Wait for Stripe API to return + form to submit

    expect(page).to have_text('Card was successfully updated')
    expect(card.reload.last_digits).to eq('5556')
    expect(card.address.address1).to eq('Alaska New Street')
  end
end

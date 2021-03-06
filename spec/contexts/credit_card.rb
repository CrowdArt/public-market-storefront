shared_context 'with filled stripe credit card in checkout' do
  before do
    setup_stripe_watcher

    stripe_iframe = all('iframe[name=__privateStripeFrame3]').last
    Capybara.within_frame stripe_iframe do
      page.find_field('Card number').set '4242 4242 4242 4242'
      page.find_field('MM / YY').set "12/#{Time.current.year + 1}"
      page.find_field('CVC').set '123'
    end

    expect(page).to have_text 'BILLING ADDRESS'

    fill_in 'Name on Card', with: 'First name Last name'
    fill_in 'First Name', with: 'First name'
    fill_in 'Last Name', with: 'Last name'
    fill_in 'Street Address', with: 'Alaska'
    fill_in 'City', with: 'Wellington'
    fill_in 'ZIP / Postal Code', with: '94001'
  end
end

shared_context 'with filled stripe card in edit form' do
  before do
    setup_stripe_watcher

    stripe_iframe = all('iframe[name=__privateStripeFrame3]').last
    Capybara.within_frame stripe_iframe do
      page.find_field('Card number').set '4000 0566 5566 5556'
      page.find_field('MM / YY').set "12/#{Time.current.year + 1}"
      page.find_field('CVC').set '911'
    end

    fill_in 'credit_card_name', with: 'First name Last name'
  end
end

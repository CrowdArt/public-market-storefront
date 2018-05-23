shared_context 'with filled stripe credit card' do
  before do
    setup_stripe_watcher

    fill_in 'name_on_card_1', with: 'First name Last name'

    stripe_iframe = all('iframe[name=__privateStripeFrame3]').last
    Capybara.within_frame stripe_iframe do
      page.find_field('Card number').set '4242 4242 4242 4242'
      page.find_field('MM / YY').set "12/#{Time.current.year + 1}"
      page.find_field('CVC').set '123'
    end

    expect(page).to have_text 'BILLING ADDRESS'

    fill_in 'payment_source_1_address_attributes_firstname', with: 'First name'
    fill_in 'payment_source_1_address_attributes_lastname', with: 'Last name'
    fill_in 'payment_source_1_address_attributes_address1', with: 'Alaska'
    fill_in 'payment_source_1_address_attributes_city', with: 'Wellington'
    fill_in 'payment_source_1_address_attributes_zipcode', with: '94001'
  end
end

require 'rails_helper'

RSpec.describe 'checkout', type: :feature, js: true, vcr: true do
  let(:vendor) { create(:vendor) }
  let(:variant) { create(:variant, vendor: vendor) }
  let(:user) { nil }

  before do
    login_as(user, scope: :spree_user) if user

    country = create(:country, states_required: true)
    create(:state, name: 'Alabama', abbr: 'AL', country: country)
    create(:free_shipping_method, vendor: vendor)

    # stripe keys are from spree_gateway gem https://github.com/spree/spree_gateway/blob/master/spec/features/stripe_checkout_spec.rb
    Spree::Gateway::StripeGateway.create!(
      name: 'Stripe',
      preferred_secret_key: 'sk_test_VCZnDv3GLU15TRvn8i2EsaAN',
      preferred_publishable_key: 'pk_test_Cuf0PNtiAkkMpTVC2gwYDMIg'
    )

    variant.stock_items.update_all(count_on_hand: 1, backorderable: false)
    visit spree.product_path(variant.product)
    click_button 'Add To Cart'

    # rubocop:disable RSpec/ExpectInHook
    expect(page).to have_text Spree.t(:added_to_cart, product: variant.product.name)
    expect(page).to have_css('.cart-info.full')
    # rubocop:enable RSpec/ExpectInHook

    first('#link-to-cart a').click
    click_button 'Checkout'
  end

  context 'when user is unathorized' do
    it { expect(page).to have_text 'Create a new account' }
  end

  context 'when user is authorized' do
    let(:user) { create(:bookstore_user) }

    it 'completes checkout process' do
      flow 'address step' do
        expect(page).to have_text 'Shipping Address'

        fill_in 'order_ship_address_attributes_firstname', with: 'First name'
        fill_in 'order_ship_address_attributes_lastname', with: 'Last name'
        fill_in 'order_ship_address_attributes_address1', with: 'Alaska'
        fill_in 'order_ship_address_attributes_city', with: 'Wellington'
        select 'Alabama', from: 'order_ship_address_attributes_state_id'
        fill_in 'order_ship_address_attributes_zipcode', with: '94001'
        fill_in 'order_ship_address_attributes_phone', with: '+19997774088'

        click_button('Save and Continue')
      end

      flow 'delivery step' do
        expect(page).to have_text 'package from'
        click_button('Save and Continue')
      end

      flow 'payment step' do
        expect(page).to have_text 'Payment Information'

        fill_in 'name_on_card_1', with: 'First name Last name'
        fill_in 'card_expiry', with: '10/18'
        fill_in 'card_number', with: '4242 4242 4242 4242'
        # Otherwise ccType field does not get updated correctly
        page.execute_script("$('.cardNumber').trigger('change')")
        fill_in 'card_code', with: '911'

        Capybara.default_max_wait_time = 10
        setup_stripe_watcher

        click_button('Save and Continue')

        wait_for_stripe # Wait for Stripe API to return + form to submit
      end

      flow 'summary order step' do
        expect(page).to have_text 'Review Order Details'

        click_button('Place Order')
        expect(page).to have_text 'Your order has been processed successfully'
      end
    end
  end
end

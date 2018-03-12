require 'rails_helper'

RSpec.describe 'checkout', type: :feature, js: true do
  let(:vendor) { create(:vendor) }
  let(:variant) { create(:variant, vendor: vendor) }
  let(:user) { nil }

  before do
    login_as(user, scope: :spree_user) if user

    country = create(:country, states_required: true)
    create(:state, name: 'Alabama', abbr: 'AL', country: country)
    create(:free_shipping_method, vendor: vendor)
    create(:check_payment_method)

    variant.stock_items.update_all(count_on_hand: 1, backorderable: false)
    visit spree.product_path(variant.product)
    click_button 'Add To Cart'

    expect(page).to have_text Spree.t(:added_to_cart, product: variant.product.name)

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
        expect(page).to have_text 'Billing Address'
        click_button('Save and Continue')
        expect(page).to have_text 'Your order has been processed successfully'
      end
    end
  end
end

require 'contexts/address'
require 'contexts/checkout'

RSpec.describe 'Shipping address in checkout flow', type: :feature, js: true, vcr: true do
  let(:user) { create(:user) }

  before do
    create(:credit_card, user: user, payment_method: create(:stripe_card_payment_method))
  end

  include_context 'with filled product cart'

  context 'when there is no pre-existing shipping address' do
    before do
      click_button 'Proceed to Checkout'
    end

    include_context 'with filled shipping address'

    it 'completes checkout process' do
      expect(page).to have_text 'SHIPPING ADDRESS'
      expect(page).not_to have_text 'Ship to existing address'

      click_button('Submit your order')

      expect(page).to have_text 'Your order has been processed successfully'
    end
  end

  context 'with existing shipping address' do
    context 'with single address' do
      before do
        create(:address, user: user)
        click_button 'Proceed to Checkout'
      end

      it 'completes checkout process' do
        expect(page).to have_text 'Ship to existing address'

        click_button('Submit your order')

        expect(page).to have_text 'Your order has been processed successfully'
      end
    end

    context 'with multiple user addresses' do
      let!(:address) { create(:address, default: true, user: user) }
      let!(:different_address) { create(:address, address1: 'Another street name', user: user) }

      before do
        click_button 'Proceed to Checkout'
      end

      it 'chooses different address' do
        click_button(address.full_address)

        page.execute_script("$(\"label[for='order_ship_address_id_#{different_address.id}']\").trigger('click')")

        click_button('Submit your order')

        expect(page).to have_text 'Your order has been processed successfully'
        expect(Spree::Order.last.shipping_address.address1).to eq different_address.address1
      end
    end
  end
end

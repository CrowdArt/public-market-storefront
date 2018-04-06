RSpec.describe 'address in checkout', type: :feature, vcr: true do
  let(:vendor) { create(:vendor) }
  let(:variant) { create(:variant, vendor: vendor) }
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :spree_user)

    create(:state, name: 'Alabama')
    create(:free_shipping_method, vendor: vendor)
    create(:stripe_card_payment_method)

    variant.stock_items.update_all(count_on_hand: 1, backorderable: false)
    visit spree.product_path(variant.product)
    click_button 'Buy Now'

    click_button 'Checkout'

    expect(page).to have_text 'Shipping Address'
  end

  shared_context 'with address' do
    before do
      fill_in 'order_ship_address_attributes_firstname', with: 'First name'
      fill_in 'order_ship_address_attributes_lastname', with: 'Last name'
      fill_in 'order_ship_address_attributes_address1', with: 'Second Street'
      fill_in 'order_ship_address_attributes_city', with: 'Wellington'
      select 'Alabama', from: 'order_ship_address_attributes_state_id'
      fill_in 'order_ship_address_attributes_zipcode', with: '94001'
      fill_in 'order_ship_address_attributes_phone', with: '+19997774088'
    end
  end

  context 'with not existing address' do
    include_context 'with address'

    it 'fills' do
      click_button('Save and Continue')

      expect(page).not_to have_text 'Shipping Address'

      expect(user.addresses.count).to eq 1
      expect(Spree::Order.last.ship_address.full_name).to eq user.addresses.first.full_name
    end
  end

  context 'with existing address' do
    let(:user) { create(:user, addresses: create_list(:address, 1, address1: 'First Street', firstname: 'First name', lastname: 'Last name')) }

    it 'chooses existing' do
      click_button('Save and Continue')

      expect(page).not_to have_text 'Shipping Address'

      expect(user.addresses.count).to eq 1
      expect(Spree::Order.last.ship_address.address1).to eq 'First Street'
    end

    context "with another user's address" do
      let!(:address) { create(:address, address1: 'Another street name', user: user) }

      before do
        click_button('Save and Continue')
        expect(page).not_to have_text 'Shipping Address'
        click_link('Address')
      end

      it 'updates existing order address' do
        choose("order_ship_address_id_#{address.id}")

        expect {
          expect {
            click_button('Save and Continue')
          }.not_to change { Spree::Order.last.ship_address_id }
        }.to change { Spree::Order.last.ship_address.address1 }
      end
    end

    describe 'can choose new', js: true do
      before { choose 'Use a new address' }

      include_context 'with address'

      it 'saves new' do
        click_button('Save and Continue')

        expect(page).not_to have_text 'Shipping Address'

        expect(user.addresses.count).to eq 2
        expect(Spree::Order.last.ship_address.address1).to eq 'Second Street'
      end
    end
  end
end

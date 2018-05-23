shared_context 'with filled shipping address' do
  before do
    fill_in 'order_ship_address_attributes_firstname', with: 'First name'
    fill_in 'order_ship_address_attributes_lastname', with: 'Last name'
    fill_in 'order_ship_address_attributes_address1', with: 'Second Street'
    fill_in 'order_ship_address_attributes_city', with: 'Wellington'
    fill_in 'order_ship_address_attributes_zipcode', with: '94001'
    fill_in 'order_ship_address_attributes_phone', with: '+19997774088'
  end
end

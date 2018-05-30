shared_context 'with filled product cart' do |args = {}|
  before do
    login_as(user, scope: :spree_user) if user

    args[:stripe_account] = true if args[:stripe_account].nil?

    vendor = create(:vendor, stripe_account: args[:stripe_account])
    country = create(:country, states_required: true)
    create(:state, name: 'Alabama', abbr: 'AL', country: country)
    create(:free_shipping_method, vendor: vendor)

    variant = create(:variant, vendor: vendor)
    variant.stock_items.update_all(count_on_hand: 1, backorderable: false)
    visit spree.product_path(variant.product)
    click_button 'Add To Cart'

    expect(page).to have_text Spree.t(:added_to_cart, product: variant.product.name)
    expect(page).to have_css('.cart-info.full')

    first('#link-to-cart a').click
  end
end

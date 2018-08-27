RSpec.describe 'populate order', type: :feature, js: true do
  let(:variant) { create(:variant) }

  before do
    variant.stock_items.update_all(count_on_hand: 1, backorderable: false)
    visit spree.product_path(variant.product)
  end

  describe 'click add to cart' do
    before { click_button 'Add To Cart' }

    it 'adds variant to order' do
      expect(page).to have_text Spree.t(:added_to_cart)
      expect(page).not_to have_text Spree.t(:shopping_cart)
    end

    context 'when already in cart' do
      before { click_button 'Add To Cart' }

      it 'shows success' do
        expect(page).to have_text Spree.t(:added_to_cart)
      end
    end
  end

  describe 'buy now' do
    before { click_button 'Buy Now' }

    it 'proceeds to order page' do
      expect(page).to have_current_path(spree.cart_path(variant_id: variant))
      expect(page).not_to have_text Spree.t(:added_to_cart, product: variant.product.name)
    end
  end
end

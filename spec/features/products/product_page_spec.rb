require 'rails_helper'

RSpec.describe 'product page', type: :feature do
  let(:taxon) { create(:taxon) }
  let(:product) { create(:product, taxons: [taxon], price: 10) }

  it 'shows no similar items' do
    visit spree.product_path(product)
    expect(page).not_to have_text Spree.t(:look_for_similar_items)
  end

  describe 'buy box', js: true do
    let(:option_type) { create(:option_type) }
    let(:first_option_value) { create(:option_value, option_type: option_type, presentation: 'First', position: 1) }
    let(:second_option_value) { create(:option_value, option_type: option_type, presentation: 'Second', position: 2) }

    let!(:first_with_min_price) { create(:variant, product: product, price: 7, option_values: [first_option_value]) }
    let!(:first_with_max_price) { create(:variant, product: product, price: 10, option_values: [first_option_value]) }

    before do
      create(:variant, product: product, price: 5, option_values: [second_option_value])
      product.variants.each { |v| v.stock_items.update_all(count_on_hand: 1, backorderable: false) }

      visit spree.product_path(product)
    end

    it 'contains price info' do
      first_avg_price = (first_with_max_price.price + first_with_min_price.price) / 2

      expect(page).to have_text(first_avg_price)
      expect(page).to have_text("$#{first_with_min_price.price}")
      expect(page).to have_text(first_avg_price - first_with_min_price.price)
      expect(page).to have_text('Save:')

      choose 'Second'

      expect(page).not_to have_text('Save:')
    end
  end
end

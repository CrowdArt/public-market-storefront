require 'rails_helper'

RSpec.describe 'product page', type: :feature do
  let(:taxon) { create(:taxon) }
  let(:product) { create(:product, taxons: [taxon]) }

  it 'shows no similar items' do
    visit spree.product_path(product)
    expect(page).not_to have_text Spree.t(:look_for_similar_items)
  end
end

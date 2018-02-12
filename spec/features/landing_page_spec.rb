require 'rails_helper'

RSpec.describe 'landing page loading', type: :feature do
  subject do
    visit '/'
    page
  end

  it { is_expected.to have_content(I18n.t('spree.no_products_found')) }
end

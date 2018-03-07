require 'rails_helper'

RSpec.describe 'error pages rendering', type: :feature do
  subject { page }

  around do |example|
    Rails.application.config.consider_all_requests_local = false
    example.run
    Rails.application.config.consider_all_requests_local = true
  end

  describe '#not_found' do
    before { visit '/404' }

    it { is_expected.to have_text('Home') }
    it { is_expected.to have_content(I18n.t('errors.error_pages.not_found')) }
    it { is_expected.to have_http_status(:not_found) }
  end

  describe '#internal_server_error' do
    before { visit '/500' }

    it { is_expected.to have_text('Home') }
    it { is_expected.to have_content(I18n.t('errors.error_pages.internal_server_error')) }
    it { is_expected.to have_http_status(:internal_server_error) }
  end
end

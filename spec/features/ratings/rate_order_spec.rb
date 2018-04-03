RSpec.describe 'rate order', type: :feature, js: true, vcr: true do
  subject(:order_page) { page }

  let!(:order) { create :shipped_order }
  let(:vendor) { create :vendor }

  before do
    order.line_items.first.variant.update(vendor: vendor)
    login_as(order.user, scope: :spree_user)
    visit spree.order_path(order)
  end

  it { is_expected.to have_text('How was your experience with this order?') }

  describe 'set positive rating' do
    before do
      find('#positive-input').click
      click_button('Send')
    end

    it { expect(order_page).to have_text('Your rating 😃') }
    it 'vendor should have positive feedback' do
      visit spree.vendor_path(vendor)
      expect(page).to have_text('Positive Feedback: 100.0%')
    end

    context 'when user updates rating to negative' do
      before do
        click_link('Update to Negative')
      end

      it { expect(order_page).to have_text('Your rating 😞') }
      it 'vendor should have N/A feedback' do
        visit spree.vendor_path(vendor)
        expect(page).to have_text('Positive Feedback: N/A')
      end
    end
  end
end

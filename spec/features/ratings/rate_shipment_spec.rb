RSpec.describe 'rate shipment', type: :feature, js: true, vcr: true do
  subject(:rate_page) { page }

  let(:order) { create :shipped_vendor_order }
  let(:shipment) { order.shipments.first }
  let(:vendor) { shipment.vendor }

  before do
    login_as(order.user, scope: :spree_user)
    visit spree.rate_shipment_path(order, shipment)
  end

  it { is_expected.to have_text("How was your experience with #{vendor.name}?") }

  describe 'set positive rating' do
    before { find('#positive').click }

    it 'show positive feedback' do
      expect(rate_page).to have_text('Take a moment to leave the merchant a positive review')
      expect(rate_page).to have_text('WRITE A REVIEW')
    end

    context 'when user left feedback' do
      let(:review) { 'some review' }

      before do
        fill_in 'review', with: review
        click_button('Submit Rating')
      end

      it 'update ratings' do
        expect(page).to have_text('100%')
        expect(page).to have_text('Your Rating: Positive')
      end

      it 'vendor should have positive feedback' do
        visit spree.vendor_path(vendor)
        expect(page).to have_text('Positive Feedback: 100%')
      end

      context 'when update feedback' do
        before do
          click_button('Update Rating')
          click_link('Proceed')
        end

        it 'show update form' do
          expect(page).to have_text('WRITE A REVIEW')
          expect(find('textarea').value).to eq(review)
        end

        context 'when change feedback to negative' do
          let(:new_review) { 'bad review' }

          before do
            find('#negative').click
            fill_in 'review', with: new_review
            click_button('Update Rating')
          end

          it 'update ratings' do
            expect(page).to have_text('N/A')
            expect(page).to have_text('Your Rating: Negative')
          end

          it 'vendor should have N/A feedback' do
            visit spree.vendor_path(vendor)
            expect(page).to have_text('Positive Feedback: N/A')
          end
        end
      end
    end
  end
end

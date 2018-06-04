RSpec.describe 'admin order', type: :feature, js: true do
  let!(:order) { create(:vendor_order_ready_to_ship, line_items_count: 2) }
  let(:line_item) { order.line_items.first }
  let(:other_line_item) { order.line_items.last }
  let(:variant) { line_item.variant }
  let(:vendor) { variant.vendor }
  let(:user) { create(:user, vendors: [vendor]) }
  let(:vendor_view) { Spree::Orders::VendorView.new(order, vendor) }

  before { login_as(user, scope: :spree_user) }

  describe 'index page' do
    before { visit spree.admin_orders_path }

    it 'show order total correctly' do
      expect(page).to have_text(line_item.price)
      expect(page).not_to have_text(order.total)
    end
  end

  describe 'edit order' do
    before { visit spree.edit_admin_order_path(order) }

    describe 'shipments' do
      it 'shows only vendor items' do
        expect(page).to have_text(variant.product.name)
        expect(page).not_to have_text(other_line_item.variant.product.name)
      end

      it 'show order total correctly' do
        expect(page).to have_text(line_item.price)
        expect(page).not_to have_text(order.total)
      end

      it 'can ship' do
        click_link 'Ship'

        expect(page).not_to have_link('Ship')
      end
    end

    describe 'cart' do
      before { click_link 'Cart' }

      it 'shows only vendor items' do
        expect(page).to have_text(variant.product.name)
        expect(page).not_to have_text(other_line_item.variant.product.name)
      end

      it 'show order total correctly' do
        expect(page).to have_text(line_item.price)
        expect(page).not_to have_text(order.total)
      end
    end

    describe 'customer' do
      before { click_link 'Customer' }

      it 'show order total correctly' do
        expect(page).to have_text(line_item.price)
        expect(page).not_to have_text(order.total)
      end
    end

    describe 'payments' do
      before { click_link 'Payments' }

      it 'show order total correctly' do
        expect(page).to have_text(line_item.price)
        expect(page).not_to have_text("Total: $#{order.total}")
      end

      it 'show transfers' do
        expect(page).to have_text('TRANSFER ID')
        expect(page).not_to have_text(order.total)
        expect(page).to have_link(class: 'action-refund')
      end

      describe 'refund transfer' do
        let!(:refund_reason) { create :refund_reason }

        before { click_link(class: 'action-refund') }

        it 'show refund page' do
          expect(page).not_to have_text(order.total)

          select refund_reason.name, from: 'Reason'

          click_button 'Refund'

          expect(page).to have_text('Refunds')
        end
      end
    end
  end
end

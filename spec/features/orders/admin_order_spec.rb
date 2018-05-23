RSpec.describe 'admin order', type: :feature, js: true do
  let(:order) { create(:vendor_order_ready_to_ship, line_items_count: 2) }
  let(:user) { create(:user, vendors: [order.line_items.first.variant.vendor]) }

  before do
    login_as user, scope: :spree_user
    visit spree.edit_admin_order_path(order)
  end

  # it { screenshot_and_open_image }
end

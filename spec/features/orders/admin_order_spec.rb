RSpec.describe 'admin order', type: :feature, js: true do
  let(:order) { create(:order_with_vendor_items, line_items_count: 2) }
  let(:user) { create(:user, vendors: [order.line_items.first.variant.vendor]) }

  before do
    login_as user, scope: :spree_user
    visit spree.edit_admin_order_path(order)
  end

  it { screenshot_and_open_image }
end

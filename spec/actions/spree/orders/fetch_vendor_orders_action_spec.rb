require 'spec_helper'

RSpec.describe Spree::Orders::FetchVendorOrdersAction, type: :action do
  subject(:orders) { described_class.new(vendor, from).call }

  let(:order) { create(:vendor_order_ready_to_ship, line_items_count: 2) }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }
  let(:from) { nil }

  it { is_expected.to include(order) }
end
